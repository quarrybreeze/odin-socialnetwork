require 'rails_helper'

RSpec.describe Follow, type: :model do
  let(:follower) { User.create!(email: 'follower@example.com', password: 'password123') }
  let(:followed_user) { User.create!(email: 'followed@example.com', password: 'password123') }
  let(:valid_attributes) { { follower: follower, followed_user: followed_user } }

  describe "validations" do
    it "is valid with valid attributes" do
      follow = Follow.new(valid_attributes)
      expect(follow).to be_valid
    end

    it "requires a follower" do
      follow = Follow.new(valid_attributes.merge(follower: nil))
      expect(follow).not_to be_valid
      expect(follow.errors[:follower]).to include("must exist")
    end

    it "requires a followed_user" do
      follow = Follow.new(valid_attributes.merge(followed_user: nil))
      expect(follow).not_to be_valid
      expect(follow.errors[:followed_user]).to include("must exist")
    end

    it "prevents duplicate follows" do
      Follow.create!(valid_attributes)
      duplicate_follow = Follow.new(valid_attributes)
      expect(duplicate_follow).not_to be_valid
      expect(duplicate_follow.errors[:follower_id]).to include("is already being followed")
    end

    it "prevents users from following themselves" do
      follow = Follow.new(follower: follower, followed_user: follower)
      expect(follow).not_to be_valid
      expect(follow.errors[:followed_user]).to include("can't follow yourself")
    end
  end

  describe "associations" do
    let(:follow) { Follow.create!(valid_attributes) }

    it "belongs to a follower (User)" do
      expect(follow.follower).to eq(follower)
    end

    it "belongs to a followed_user (User)" do
      expect(follow.followed_user).to eq(followed_user)
    end
  end
end
