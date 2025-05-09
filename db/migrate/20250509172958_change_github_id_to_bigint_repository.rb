class ChangeGithubIdToBigintRepository < ActiveRecord::Migration[7.2]
  def change
    change_column :repositories, :github_id, :bigint
  end
end
