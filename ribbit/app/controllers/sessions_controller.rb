class SessionsController < ApplicationController

  def create
    user = User.find_by_username params[:username]
    # user = User.find_by username: params[:username] # rails4
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, notice: "Logged In!"
    else
      flash[:error] = "Wrong username or password."
      redirect_to root_url
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged Out."
  end
end
