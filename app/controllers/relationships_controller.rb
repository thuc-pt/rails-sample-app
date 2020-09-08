class RelationshipsController < ApplicationController
  before_action :logged_in?

  def create
    user = User.find_by id: params[:followed_id]
    if user
      current_user.follow user
      redirect_to user
    else
      flash[:danger] = t ".not_found"
      redirect_to root_path
    end
  end

  def destroy
    user = Relationship.find_by(id: params[:id])
    if user
      user = user.followed
      current_user.unfollow user
      redirect_to user
    else
      flash[:danger] = t ".not_found"
      redirect_to root_path
    end
  end
end
