class AddNewColumnsToChecks < ActiveRecord::Migration[7.2]
  def change
    add_column :repository_checks, :summary, :jsonb, default: {}, null: false
    add_column :repository_checks, :files, :jsonb, default: [], null: false
  end
end
