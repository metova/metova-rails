class Api::PostsController < Api::BaseController

  respond_to :json
  before_action :authenticate_api_user!, only: :secret

  def index
    user = User.find params[:user_id]
    @posts = user.posts
    @posts = @posts.filter(params[:query]) if params[:query]
    respond_with @posts
  end

  def secret
    head 204
  end

end
