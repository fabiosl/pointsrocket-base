class AddSocialInteractionsMultiplierToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :social_interactions_multiplier, :float
  end
end
