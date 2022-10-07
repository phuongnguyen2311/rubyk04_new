class RemoveClientFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_reference :microposts, :author, null: false, foreign_key: true
  end
end
