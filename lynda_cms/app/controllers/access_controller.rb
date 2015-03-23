class AccessController < ApplicationController

  layout 'admin'

  before_action :confirm_logged_in, :except => [:login, :attempt_login, :logout]

  # CTRL za login/logout

  def index
    # display text & links
  end

  def login
    # login form
  end

  def attempt_login
    if params[:username].present? && params[:password].present?
      found_user = AdminUser.where(username: params[:username]).first
      if found_user
        authorized_user = found_user.authenticate(params[:password])
      end
    end

    if authorized_user
      # SESSION
      session[:user_id] = authorized_user.id
      session[:username] = authorized_user.username

      flash[:notice] = "You are now logged in."
      redirect_to action: 'index'
    else
      flash[:notice] = "Invalid username/password combination."
      redirect_to action: 'login'
    end
  end

  def logout
    session[:user_id] = nil
    session[:username] = nil

    flash[:notice] = "You are logged out"
    redirect_to action: 'login'
  end


  # PREBACENO U APPLICATIONCONTROLLER DA BI DOSTUPAN SVIM CTRL
  #
  # private
  #
  # # Login check
  # def confirm_logged_in
  #   unless session[:user_id]
  #     flash[:notice] = 'Please log in.'
  #     redirect_to action: 'login'
  #     return false # halts the before_actoin
  #   else
  #     return true # return true nije obavezan, bitan je FALSE
  #   end
  # end

end
