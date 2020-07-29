class RemoveChallengeHashtagFields < ActiveRecord::Migration
  def change
    remove_column :challenges, :hashtag
    remove_column :challenges, :social_interactions_multiplier
    remove_column :challenges, :challenge_type
  end
end
