class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :commentator, class_name: "User"
end
