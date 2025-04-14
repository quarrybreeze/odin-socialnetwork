class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :authored_posts, class_name: "Post", foreign_key: "author_id"
  has_many :likes, dependent: :destroy

  has_many :followed_by, foreign_key: :followed_user_id, class_name: "Follow", dependent: :destroy
  has_many :followers, through: :followed_by, source: :follower

  has_many :following, foreign_key: :follower_id, class_name: "Follow", dependent: :destroy
  has_many :following, through: :following, source: :followed_user
end
