class RemoveRecommendationFromChallengeUsers < ActiveRecord::Migration
  def change
    remove_column :challenge_users, :recommendation, :string
  end
end
