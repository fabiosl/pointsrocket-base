class AddChallengeTypeToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :challenge_type, :string, default: "link"
  end
end
