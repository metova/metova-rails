class Api::PostsController < Api::BaseController

  respond_to :json
  before_action :authenticate_api_user!, only: :secret

  def index
    user = User.find params[:user_id]
    @posts = user.posts
    respond_with @posts
  end

  def secret
    head 204
  end

end
