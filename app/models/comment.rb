class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :commentator, class_name: "User"

  validates :body, presence: true, length: { maximum: 1000 }
  validates :post, presence: true
  validates :commentator, presence: true

  scope :ordered, -> { order(created_at: :desc) }
end
