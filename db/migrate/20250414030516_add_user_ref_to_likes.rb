class AddUserRefToUpvotes < ActiveRecord::Migration[8.0]
  def change
    add_reference :upvotes, :user, null: false, foreign_key: true
  end
end
