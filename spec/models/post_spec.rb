require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { User.create(email: 'test@example.com', password: 'password123') }
  let(:user2) { User.create(email: 'test2@example.com', password: 'password123') }
  let(:post) { Post.new(body: 'Test post content', author: user) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(post).to be_valid
    end

    it "requires a body" do
      post.body = nil
      expect(post).not_to be_valid
      expect(post.errors[:body]).to include("can't be blank")
    end

    it "requires an author" do
      post.author = nil
      expect(post).not_to be_valid
      expect(post.errors[:author]).to include("must exist")
    end
  end

  describe "associations" do
    it "belongs to an author (User)" do
      post.save!
      expect(post.author).to eq(user)
    end

    it "can have many likes" do
      post.save!
      like1 = Like.create(liker: user, post: post)
      like2 = Like.create(liker: user2, post: post)
      expect(post.likes).to match_array([ like1, like2 ])
    end

    it "destroys associated likes when post is destroyed" do
      post.save!
      Like.create(liker: user, post: post)
      expect { post.destroy }.to change { Like.count }.by(-1)
    end

    it "can have many comments" do
      post.save!
      comment1 = Comment.create(body: 'First comment', commentator: user, post: post)
      comment2 = Comment.create(body: 'Second comment', commentator: user, post: post)
      expect(post.comments).to match_array([ comment1, comment2 ])
    end

    it "destroys associated comments when post is destroyed" do
      post.save!
      Comment.create(body: 'Test comment', commentator: user, post: post)
      expect { post.destroy }.to change { Comment.count }.by(-1)
    end
  end

  describe "#like_count" do
    it "returns the number of likes for the post" do
      post.save!
      Like.create(liker: user, post: post)
      expect(post.like_count).to eq(1)
    end
  end

  describe "#comment_count" do
    it "returns the number of comments for the post" do
      post.save!
      Comment.create(body: 'Test comment', commentator: user, post: post)
      expect(post.comment_count).to eq(1)
    end
  end
end
