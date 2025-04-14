class CommentsController < ApplicationController

  def new
    @comment = Comment.new
  end

  def create
    @commented_post = Post.find(params[:comment][:post_id])
    @comment = @commented_post.comments.new(comment_params.merge(commentator_id: current_user.id))
    if @comment.save
      redirect_back fallback_location: root_path, notice: "You commented on #{@commented_post.author.email}'s post."
    else
      redirect_back fallback_location: root_path, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_back fallback_location: root_path, notice: "You deleted your comment."
  end

  private
  def comment_params
    params.require(:comment).permit(:body, :post_id)
  end
end
