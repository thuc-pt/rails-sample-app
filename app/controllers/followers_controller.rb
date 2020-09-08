class FollowersController < ApplicationController
  before_action :load_user

  def index
    @title = t ".followers"
    @follow_users = @user.followers.paginate page: params[:page],
      per_page: Settings.user_items
  end

  private

  def load_user
    @user = User.find_by id: params[:user_id]
    return if @user
    flash[:danger] = t ".not_found"
    redirect_to root_path
  end
end
