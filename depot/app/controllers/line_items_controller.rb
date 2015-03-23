class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:create] # includovano iz concern

  before_action :set_line_item, only: [:show, :edit, :update, :destroy]
  skip_before_action :authorize, only: :create

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    # product_id iz sessiona (prosledjen sa post)
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id) # cart#add_product

    # @cart = iz CurrentCart concern module (f() set_cart)
    # .build = sinonim za NEW, ali se vise koristi kod has_many obj
    #
    # RAILS GUIDE RELATIONS:
    # @order = Order.create(order_date: Time.now, customer_id: @customer.id)
    #
    # @order = @customer.orders.create(order_date: Time.now) # sa relacijom
    # --> Kreira novi order za odredjenu customer
    # @line_item = @cart.line_items.build(product: product)

    respond_to do |format|
      if @line_item.save
        # @line_item.cart > vrsi redirect ka Cart
        # store_url = root
        format.html { redirect_to store_url }

        # create.js.erb, ovo odgovara na AJAX requestove
        format.js { @current_item = @line_item }
        format.json { render action: 'show', status: :created, location: @line_item }
      else
        format.html { render action: 'new' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to line_items_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:product_id)
    end
end
