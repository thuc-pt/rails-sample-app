class MicropostsController < ApplicationController
  before_action :logged_in?
  before_action :load_post, except: :create

  def edit; end

  def create
    @post = current_user.microposts.new post_params
    if @post.save
      flash[:success] = t ".success"
      redirect_to root_path
    else
      @posts = current_user.filter_post.paginate page: params[:page],
        per_page: Settings.post_items
      render "static_pages/home"
    end
  end

  def update
    if @post.update post_params
      redirect_to root_path
      flash[:success] = t ".success"
    else
      flash.now[:danger] = t ".fail"
      render :edit
    end
  end

  def destroy
    if @post.destroy
      flash[:success] = t ".success"
      redirect_to request.referrer
    else
      flash[:danger] = t ".can't_delete"
      redirect_to root_path
    end
  end

  private

  def post_params
    params.require(:micropost).permit :content, :picture
  end

  def load_post
    @post = current_user.microposts.find_by id: params[:id]
    return if @post
    flash[:danger] = t ".not_found"
    redirect_to request.referrer
  end
end
