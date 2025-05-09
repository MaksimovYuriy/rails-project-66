class RenameColumnStateRepositoryCheck < ActiveRecord::Migration[7.2]
  def change
    rename_column :repository_checks, :state, :aasm_state
  end
end
