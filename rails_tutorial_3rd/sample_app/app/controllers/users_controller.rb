class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy] # logged_in_user > application_ctrl
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def index
    # @users = User.all
    # @users = User.paginate(page: params[:page]) # params[:page] generisano od strane will_paginate
    # .where je select db query
    @users = User.where(activated: true).paginate(page: params[:page]) # 10.5 exercize 2
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate( page: params[:page])
    redirect_to root_url and return unless @user # 10.5 exercize 2
    # debugger # byebug gem
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_mail
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    # @user = User.find(params[:id]) # correct_user vec ubacuje
  end

  def update
    # @user = User.find(params[:id]) # correct_user vec ubacuje
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success]  = "User deleted."
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end


    # BEFORE FILTERS


    # Provera da li edit/update akciju pokusava pravi user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Admin user chekc
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
