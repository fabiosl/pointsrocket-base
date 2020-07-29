class AddFeedbackToHashtagChallengeUsers < ActiveRecord::Migration
  def change
    add_column :hashtag_challenge_users, :feedback, :text
  end
end
