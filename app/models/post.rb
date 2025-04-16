class Post < ApplicationRecord
  belongs_to :author, class_name: "User"
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :body, presence: true
  validates :author, presence: true

  def like_count
    likes.count
  end

  def comment_count
    comments.count
  end
end
