class LikesController < ApplicationController
  def create
    @liked_post = Post.find(params[:post_id])
    @like = @liked_post.likes.new(user_id: current_user.id)

    if @like.save
      redirect_back fallback_location: root_path, notice: "You liked #{@liked_post.author.display_name}'s post."
    else
      redirect_back fallback_location: root_path, status: :unprocessable_entity
    end
  end

  def destroy
    @liked_post = Post.find(params[:post_id])
    @like = @liked_post.likes.find_by(user_id: current_user.id)
    @like.destroy
    redirect_back fallback_location: root_path, notice: "You unliked #{@liked_post.author.display_name}'s post."
  end
end
