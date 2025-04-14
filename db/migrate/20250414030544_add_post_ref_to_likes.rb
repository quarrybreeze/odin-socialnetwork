class AddPostRefToUpvotes < ActiveRecord::Migration[8.0]
  def change
    add_reference :upvotes, :post, null: false, foreign_key: true
  end
end
