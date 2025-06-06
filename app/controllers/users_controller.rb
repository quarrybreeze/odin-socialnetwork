class UsersController < ApplicationController
  def index
    @users = User.includes(:followers).all
  end

  def show
    @user = User.includes(:authored_posts, :followers).find(params[:id])
    @followers = @user.followers
    @follower_count = @followers.count
    @comment = Comment.new
  end
end
