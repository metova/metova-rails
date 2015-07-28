class PostsController < ApplicationController
  before_action :authenticate_user!
end
