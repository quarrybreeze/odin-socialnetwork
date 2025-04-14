class AddUserRefToComments < ActiveRecord::Migration[8.0]
  def change
    add_reference :comments, :commentator, null: false, foreign_key: { to_table: :users }
  end
end
