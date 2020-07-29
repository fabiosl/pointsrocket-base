class AddUsersToHashtagChallengeUsers < ActiveRecord::Migration
  def change
    add_reference :hashtag_challenge_users, :user, index: true
  end
end
