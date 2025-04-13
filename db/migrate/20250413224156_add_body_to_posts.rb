class AddBodyToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :body, :string, null: false
  end
end
