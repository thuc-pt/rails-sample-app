class PasswordResetsController < ApplicationController
  before_action :find_user, only: :create
  before_action :load_user, :valid_user, :time_out, only: [:edit, :update]

  def new; end

  def edit; end

  def create
    @user.create_reset_password_digest
    @user.send_password_reset_email
    flash[:info] = t ".sent"
    redirect_to root_path
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t(".blank")
      render :edit
    elsif @user.update params_user
      login @user
      @user.clear_reset_digest
      flash[:success] = t ".success"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def find_user
    @user = User.find_by email: params[:reset][:email]
    return if @user
    flash.now[:danger] = t ".invalid"
    render :new
  end

  def params_user
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user
    flash[:danger] = t ".not_found"
    redirect_to root_path
  end

  def valid_user
    return if @user&.activated? && @user.authenticate?(:reset, params[:id])
    flash[:danger] = t ".invalid"
    redirect_to root_path
  end

  def time_out
    return if @user.not_time_out?
    flash[:danger] = t ".time_out"
    redirect_to new_password_reset_path
  end
end
