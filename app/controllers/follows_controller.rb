class FollowsController < ApplicationController
  def new
    # @follow = Follow.new
  end

  def create
    @followed_user = User.find(params[:user_id])
    @follow = @followed_user.followed_by.new(follower: current_user)

    if @follow.save
      redirect_to users_path, notice: "You are now following #{@followed_user.email}."
    else
      redirect_to users_path, status: :unprocessable_entity
    end
  end

  def destroy
    @followed_user = User.find(params[:user_id])
    @follow = @followed_user.followed_by.find_by(follower: current_user)
    @follow.destroy
    redirect_to users_path, notice: "You have unfollowed #{@followed_user.email}."
  end

  private
  # def follow_params
  #   params.require(:follow).permit(:followed_user_id)
  # end
end
