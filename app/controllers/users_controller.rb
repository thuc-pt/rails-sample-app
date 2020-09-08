class UsersController < ApplicationController
  before_action :logined, except: [:new, :create]
  before_action :load_user, except: [:index, :new, :create]
  before_action :edit_profile, only: [:edit, :update]
  before_action :delete_user, only: :destroy

  def index
    @users = User.paginate page: params[:page], per_page: Settings.user_items
  end

  def show
    @posts = @user.microposts.paginate page: params[:page],
      per_page: Settings.post_items
    @follow = current_user.active_relationships.new
    @unfollow = current_user.active_relationships.find_by followed_id: @user.id
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_email_activation_account
      flash[:info] = t ".check_email"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".success"
      redirect_to @user
    else
      flash.now[:danger] = t ".fails"
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t ".delete"
    redirect_to users_path
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t ".not_found"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit :name, :email,
      :password, :password_confirmation
  end

  def logined
    return if current_user.present?
    flash[:danger] = t ".check_login"
    redirect_to signin_path
  end

  def edit_profile
    return if @user == current_user
    flash[:danger] = t ".check_edit"
    redirect_to edit_user_path current_user
  end

  def delete_user
    return if current_user.admin?
    flash[:danger] = t ".notdelete"
    redirect_to users_path
  end
end
