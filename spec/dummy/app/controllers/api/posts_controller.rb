class Api::PostsController < Api::BaseController

  respond_to :json
  before_action :authenticate_api_user!, only: :secret

  def index
    user = User.find params[:user_id]
    @posts = user.posts
    @posts = @posts.filter(params[:query]) if params[:query]
    respond_with @posts
  end

  def show
    @post = Post.find params[:id]
    respond_with @post
  end

  def secret
    head 204
  end

  def update
    @post = Post.find params[:id]
    @post.update permitted_params
    respond_with @post
  end

  def display_resource_on_put_and_delete?
    false
  end

  private
    def permitted_params
      params.require(:post).permit :title
    end
end
