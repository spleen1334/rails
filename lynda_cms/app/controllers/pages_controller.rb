class PagesController < ApplicationController

  layout 'admin'

  before_action :confirm_logged_in # authentication
  before_action :find_subject # subject > subject_id > uzimaju se pages za subject_id

  def index
    # @pages = Page.sorted
    #
    # @pages = Page.where(:subject_id => @subject.id).sorted
    @pages = @subject.pages.sorted # isto sto i gornje, relation iz has_many
  end

  def show
    @page = Page.find(params[:id])
  end

  def new
    @page = Page.new({ subject_id: @subject.id, name: "Placeholder name" })
    @subjects = Subject.order('position ASC')
    @page_count = Page.count + 1
  end

  def create
    @page = Page.new(page_params)

    if @page.save
      flash[:notice] = "Page has been created successfully."
      redirect_to action: 'index', subject_id: @subject.id
    else
      @subjects = Subject.order('position ASC')
      @page_count = Page.count + 1
      render 'new'
    end
  end

  def edit
    @page = Page.find(params[:id])
    @subjects = Subject.order('position ASC')
    @page_count = Page.count
  end

  def update
    @page = Page.find(params[:id])

    if @page.update_attributes(page_params)
      flash[:notice] = "Page has been updated successfully."
      redirect_to action: 'show', id: @page.id, subject_id: @subject.id
    else
      @subjects = Subject.order('position ASC')
      @page_count = Page.count
      redirect_to 'edit'
    end

  end

  def delete
    @page = Page.find(params[:id])
  end

  def destroy
    page = Page.find(params[:id]).destroy
    flash[:notice] = 'Page has been successfully deleted.'
    redirect_to action: 'index', subject_id: @subject.id

  end


  private

    def page_params
      params.require(:page).permit(:subject_id, :name, :permalink, :position, :visible)
    end

    def find_subject
      if params[:subject_id]
        @subject = Subject.find(params[:subject_id])
      end
    end
end
