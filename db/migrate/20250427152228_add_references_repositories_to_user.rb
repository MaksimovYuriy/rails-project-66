class AddReferencesRepositoriesToUser < ActiveRecord::Migration[7.2]
  def change
    add_reference :repositories, :user, index: true
  end
end
