class UsersController < ApplicationController

  def new
    if current_user
      redirect_to buddies_path
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id # logovan user nakon kreiranja accounta
      redirect_to @user, notice: "Thank you for signing up for Ribbit!" # show
    else
      render 'new'
    end
  end

  def index
    @users =User.all
    @ribbit = Ribbit.new
  end

  def buddies
    if current_user
      @ribbit = Ribbit.new
      # Category.all.map(&:id)
      # Category.all.map { |a| a.id  }
      buddies_ids = current_user.followeds.map(&:id).push(current_user.id)

      @ribbits = Ribbit.find_all_by_user_id(buddies_ids) #
    else
      redirect_to root_url
    end
  end

  def show
    @user = User.find(params[:id])
    @ribbit = Ribbit.new # zbog partial ribbit_new_form

    @relationship = Relationship.where(
      follower_id: current_user.id,
      followed_id: @user.id
    ).first_or_initialize if current_user
  end

  def edit
    @user = User.find(params[:id])

    # Ovo mozda moze drugacije u Rails4
    # Bez ovoga svaki user moze da ukuca /users/1/edit i ima pristup za
    # editovanje celog profile
    redirect_to @user unless @user == current_user
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to @user, notice: "Profile Updaetd!"
    else
      render 'edit'
    end
  end
end
