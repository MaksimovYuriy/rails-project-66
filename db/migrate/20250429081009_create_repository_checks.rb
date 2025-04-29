class CreateRepositoryChecks < ActiveRecord::Migration[7.2]
  def change
    create_table :repository_checks do |t|
      t.references :repository, null: false, foreign_key: true
      t.string :state
      t.text :output
      t.integer :offenses_count

      t.timestamps
    end
  end
end
