class AccountActivationsController < ApplicationController
  before_action :load_user, only: :edit

  def edit
    if @user&.authenticate?(:activation, params[:id])
      @user.active_account
      login @user
      flash[:success] = t ".success"
      redirect_to @user
    else
      flash[:danger] = t ".invalid"
      redirect_to root_path
    end
  end

  private

  def load_user
    @user = User.find_by email: params[:email]
    return if @user&.activated.blank?
    flash[:danger] = t ".fail"
    redirect_to root_path
  end
end
