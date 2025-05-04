class ChangeFilesDefaultInRepositoryChecks < ActiveRecord::Migration[7.2]
  def change
    change_column_default :repository_checks, :files, from: [], to: {}
  end
end
