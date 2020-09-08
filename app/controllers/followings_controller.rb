class FollowingsController < ApplicationController
  before_action :load_user

  def index
    @title = t ".following"
    @follow_users = @user.following.paginate page: params[:page],
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
