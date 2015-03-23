class SectionsController < ApplicationController

  # Section.count >> PROBLEM
  # Zbog toga je instaliran acts_as_list gem.
  # Bez gema on uzima sve sectione, bez obzira da li oni pripadaju nekom page
  # ili ne.
  # Zahvaljujuci gemu scope je suzen samo na one sections koji pripadaju
  # odgovarajucem Page

  layout 'admin'

  before_action :confirm_logged_in
  before_action :find_page # pages > page_id > sekcije za page_id

  def index
    # @sections = Section.sorted
    @sections = @page.sections.sorted
  end

  def show
    @section= Section.find(params[:id])
  end

  def new
    @section = Section.new({name: "Placeholder name"})
    # @pages = Page.order('position ASC')
    @pages = @page.subject.pages.sorted
    @section_count = Section.count + 1 # OVO CE PRAVITI PROBLEM, zato instaliramo custom gem
  end

  def create
    @section = Section.new(section_params)

    if @section.save
      flash[:notice] = "Section has been created successfully."
      redirect_to action: 'index'
    else
      # @pages = Page.order('position ASC')
      @pages = @page.subject.pages.sorted
      @section_count = Section.count + 1
      render 'new'
    end
  end

  def edit
    @section = Section.find(params[:id])
    # @pages = Page.order('position ASC')
    @pages = @page.subject.pages.sorted
    @section_count = Section.count
  end

  def update
    @section = Section.find(params[:id])

    if @section.update_attributes(section_params)
      flash[:notice] = "Section has been updated successfully."
      redirect_to action: 'show', id: @section.id, :page_id => @page.id
    else
      # @pages = Page.order('position ASC')
      @pages = @page.subject.pages.sorted
      @section_count = Section.count
      redirect_to 'edit'
    end
  end

  def delete
    section = Section.find(params[:id])
  end

  def destroy
    section = Section.find(params[:id]).destroy
    flash[:notice] = "Section destroyed successfully."
    redirect_to(:action => 'index', :page_id => @page.id)
  end


  private

    def section_params
      params.require(:section).permit(:page_id, :name, :position, :visible, :content_type, :content)
    end

    def find_page
      if params[:page_id]
        @page = Page.find(params[:page_id])
      end
    end


end
