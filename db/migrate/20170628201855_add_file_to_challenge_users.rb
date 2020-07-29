class AddFileToChallengeUsers < ActiveRecord::Migration
  def change
    add_column :challenge_users, :file, :string
  end
end
