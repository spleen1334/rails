class AdminController < ApplicationController
  before_action :authorize # pre svih akciju u ctrl, zato sto je u app_ctrl onda je pre svih akciju u svim ctrl

  def index
    @total_orders = Order.count
  end


  protected

    def authorize
      unless User.find_by(id: session[:user_id])
        redirect_to login_url, notice: "Please log in"
      end
    end
end
