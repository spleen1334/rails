class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # login provera za aktivated account
      if user.activated?
        # Loged in, redirect to show page
        log_in user
        # cookies remember u session helper koji pozivi originalni model remember
        # method
        # remember user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user) # nova fancy fora za remember checkbox
        # redirect_to user # isto sto i: users_path(user)
        redirect_back_or user #friendly redirect
      else
        message = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # flash[:danger] = 'Invalid email/password combination' # flash ostaje 1 req duze nego sto treba
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in? # bugix 8.4.4.
    redirect_to root_url
  end
end
