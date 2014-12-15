class Api::PostsController < Api::BaseController

  respond_to :json

  def index
    user = User.find params[:user_id]
    @posts = user.posts
    respond_with @posts
  end

end
