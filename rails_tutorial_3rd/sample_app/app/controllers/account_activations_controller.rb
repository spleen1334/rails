class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    # !user.activated? > provera da bi sprecila da se link salje vec
    # aktiviranom accountu
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate # model method za aktivaciju accounta

      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end

end
