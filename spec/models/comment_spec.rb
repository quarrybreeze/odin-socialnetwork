require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { User.create!(email: 'user@example.com', password: 'password123') }
  let(:post) { Post.create!(body: 'Test post', author: user) }
  let(:valid_attributes) { { body: 'Great post!', post: post, commentator: user } }

  describe "validations" do
    it "is valid with valid attributes" do
      comment = Comment.new(valid_attributes)
      expect(comment).to be_valid
    end

    it "requires a body" do
      comment = Comment.new(valid_attributes.merge(body: nil))
      expect(comment).not_to be_valid
      expect(comment.errors[:body]).to include("can't be blank")
    end

    it "requires a post" do
      comment = Comment.new(valid_attributes.merge(post: nil))
      expect(comment).not_to be_valid
      expect(comment.errors[:post]).to include("must exist")
    end

    it "requires a commentator" do
      comment = Comment.new(valid_attributes.merge(commentator: nil))
      expect(comment).not_to be_valid
      expect(comment.errors[:commentator]).to include("must exist")
    end

    it "validates maximum length of body" do
      comment = Comment.new(valid_attributes.merge(body: 'a' * 1001))
      expect(comment).not_to be_valid
      expect(comment.errors[:body]).to include("is too long (maximum is 1000 characters)")
    end
  end

  describe "associations" do
    let(:comment) { Comment.create!(valid_attributes) }

    it "belongs to a post" do
      expect(comment.post).to eq(post)
    end

    it "belongs to a commentator (User)" do
      expect(comment.commentator).to eq(user)
    end
  end

  describe "scopes" do
    let!(:old_comment) { Comment.create!(valid_attributes.merge(created_at: 2.days.ago)) }
    let!(:new_comment) { Comment.create!(valid_attributes.merge(body: 'New comment')) }

    it "orders by newest first" do
      expect(Comment.ordered).to eq([ new_comment, old_comment ])
    end
  end
end
