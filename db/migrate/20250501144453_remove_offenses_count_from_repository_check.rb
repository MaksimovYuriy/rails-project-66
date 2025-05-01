class RemoveOffensesCountFromRepositoryCheck < ActiveRecord::Migration[7.2]
  def change
    remove_column :repository_checks, :offenses_count
  end
end
