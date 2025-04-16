require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123') }
  let(:post) { Post.create!(body: 'Test post', author: user) }
  let(:valid_attributes) { { post: post, liker: user } }

  describe "validations" do
    it "is valid with valid attributes" do
      like = Like.new(valid_attributes)
      expect(like).to be_valid
    end

    it "requires a post" do
      like = Like.new(valid_attributes.merge(post: nil))
      expect(like).not_to be_valid
      expect(like.errors[:post]).to include("must exist")
    end

    it "requires a liker" do
      like = Like.new(valid_attributes.merge(liker: nil))
      expect(like).not_to be_valid
      expect(like.errors[:liker]).to include("must exist")
    end

    it "prevents duplicate likes by the same user on the same post" do
      Like.create!(valid_attributes)
      duplicate_like = Like.new(valid_attributes)
      expect(duplicate_like).not_to be_valid
      expect(duplicate_like.errors[:user_id]).to include("has already liked this post")
    end
  end

  describe "associations" do
    let(:like) { Like.create!(valid_attributes) }

    it "belongs to a post" do
      expect(like.post).to eq(post)
    end

    it "belongs to a liker (User)" do
      expect(like.liker).to eq(user)
    end
  end

  describe "callbacks" do
    it "updates the post's like count when created" do
      expect {
        Like.create!(valid_attributes)
      }.to change { post.reload.like_count }.by(1)
    end

    it "updates the post's like count when destroyed" do
      like = Like.create!(valid_attributes)
      expect {
        like.destroy
      }.to change { post.reload.like_count }.by(-1)
    end
  end
end
