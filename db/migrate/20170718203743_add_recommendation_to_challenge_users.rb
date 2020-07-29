class AddRecommendationToChallengeUsers < ActiveRecord::Migration
  def change
    add_column :challenge_users, :recommendation, :string
  end
end
