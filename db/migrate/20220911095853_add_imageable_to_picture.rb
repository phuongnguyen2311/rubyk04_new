class AddImageableToPicture < ActiveRecord::Migration[6.1]
  def change
    add_reference :pictures, :imageable, polymorphic: true
  end
end
