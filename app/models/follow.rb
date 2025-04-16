class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed_user, class_name: "User"

  validates :follower, presence: true
  validates :followed_user, presence: true
  validates :follower_id, uniqueness: { scope: :followed_user_id, message: "is already being followed" }
  validate :cannot_follow_self

  private

  def cannot_follow_self
    if follower_id == followed_user_id
      errors.add(:followed_user, "can't follow yourself")
    end
  end
end
