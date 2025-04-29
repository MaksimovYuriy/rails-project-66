class AddColumnToRepositoryCheck < ActiveRecord::Migration[7.2]
  def change
    add_column :repository_checks, :commit_id, :string
  end
end
