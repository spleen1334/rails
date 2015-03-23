class PasswordResetsController < ApplicationController

  before_action :get_user,         only: [:edit, :update]
  before_action :valid_user,       only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]


  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email send with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found" # prikazi odmah
      render 'new'
    end
  end


  def edit
  end

  # Cetiri slucaja za update password
  # 1. expired password reset (check_expiration)
  # 2. successful update (elsif)
  # 3. failed update invalid password (model length validation)
  # 4. failed update zbog blank password i confirmation (if password blank?)
  def update
    if password_blank?
      flash.now[:danger] = "Password can't be blank"
      render 'edit'
    elsif @user.update_attributes(user_params)
        log_in @user
        flash[:success] = "Password has been reset."
        redirect_to @user
    else
      render 'edit'
    end
  end



  private

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Provera da li user: postoji, aktiviran, authenticated
    def valid_user
      unless (@user && @user.activated && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end


    # Klasican nacin za ucitavanje params
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def password_blank?
      params[:user][:password].blank?
    end

    # Provera da li je istekao password reset token
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
