class PublicController < ApplicationController

  layout 'public'

  # Navbar info
  before_action :setup_navigation

  def index
    # intro text nista vise
  end

  def show
    # :permalink iz route
    @page = Page.where(:permalink => params[:permalink], :visible => true).first
    if @page.nil?
      redirect_to action: 'index'
    else
      # display page with show.html.erb
    end
  end

  private

    def setup_navigation
      @subjects = Subject.visible.sorted
    end
end
