class AddRecommendationToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :recommendation, :text
  end
end
