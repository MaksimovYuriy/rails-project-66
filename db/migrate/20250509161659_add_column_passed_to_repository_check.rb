class AddColumnPassedToRepositoryCheck < ActiveRecord::Migration[7.2]
  def change
    add_column :repository_checks, :passed, :boolean, :default => nil
  end
end
