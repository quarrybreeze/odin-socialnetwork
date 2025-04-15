class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    following_ids = current_user.following.pluck(:id) << current_user.id
    @posts = Post.includes(:author, :likes, :comments)
                 .where(author_id: following_ids)
                 .order(created_at: :desc)
    @comment = Comment.new
    @post = Post.new
  end

  def new
    @post = Post.new
  end

  def show
    @post = Post.includes(:likes).find(params[:id])
    @likes = @post.likes
    @like_count = @likes.count
    @comment = Comment.new
    @comments = @post.comments
  end

  def create
    @post = Post.new(post_params.merge(author_id: current_user.id))
    if @post.save
      redirect_back fallback_location: root_path, notice: "Post was created successfully"
    else
      redirect_back fallback_location: root_path, status: :unprocessable_entity
    end
  end

  private
  def post_params
    params.require(:post).permit(:author_id, :body)
  end
end
