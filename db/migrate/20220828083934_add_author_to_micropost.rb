class AddAuthorToMicropost < ActiveRecord::Migration[6.1]
  def change
    add_reference :microposts, :author, null: false, foreign_key: true
  end
end
