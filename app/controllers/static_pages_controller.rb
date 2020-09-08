class StaticPagesController < ApplicationController
  def home
    return if current_user.nil?
    @post = current_user.microposts.build
    @posts = current_user.filter_post.paginate page: params[:page],
      per_page: Settings.post_items
  end

  def about; end

  def contact; end

  def help; end
end
