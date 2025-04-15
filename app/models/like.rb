class Like < ApplicationRecord
  belongs_to :post
  belongs_to :liker, class_name: "User", foreign_key: "user_id"
end
