class Like < ApplicationRecord
  belongs_to :post
  belongs_to :liker, class_name: "User", foreign_key: "user_id"

  validates :post, presence: true
  validates :liker, presence: true
  validates :user_id, uniqueness: { scope: :post_id, message: "has already liked this post" }
end
