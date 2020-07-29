class AddJsonToChallengeUsers < ActiveRecord::Migration
  def change
    add_column :challenge_users, :json, :text
    add_column :challenge_users, :social_id, :string
  end
end
