class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.includes(:author, :likes).all
  end

  def new
    @post = Post.new
  end

  def show
    @post = Post.includes(:likes).find(params[:id])
    @likes = @post.likes
    @like_count = @likes.count
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to post_path(@post), notice: "Post was created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
  def post_params
    params.require(:post).permit(:author_id, :body)
  end
end
