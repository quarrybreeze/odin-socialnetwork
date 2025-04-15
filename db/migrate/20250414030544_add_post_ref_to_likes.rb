class AddPostRefToLikes < ActiveRecord::Migration[8.0]
  def change
    add_reference :likes, :post, null: false, foreign_key: true
  end
end
