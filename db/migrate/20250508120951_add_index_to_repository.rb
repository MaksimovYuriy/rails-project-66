class AddIndexToRepository < ActiveRecord::Migration[7.2]
  def change
    add_index :repositories, :full_name, unique: true
  end
end
