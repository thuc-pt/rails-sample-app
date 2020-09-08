class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new; end

  def create
    if @user.activated?
      login @user
      remember @user if params[:session][:remember] == Settings.remember
      flash[:success] = t ".success"
      redirect_to @user
    else
      flash[:warning] = t ".check_email"
      redirect_to signin_path
    end
  end

  def destroy
    signout if current_user.present?
    flash[:success] = t ".logout"
    redirect_to root_url
  end

  private

  def load_user
    @user = User.find_by email: params[:session][:email].downcase
    return if @user&.authenticate params[:session][:password]
    flash.now[:danger] = t ".danger"
    render :new
  end
end
