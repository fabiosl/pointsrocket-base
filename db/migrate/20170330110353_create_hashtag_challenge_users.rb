class CreateHashtagChallengeUsers < ActiveRecord::Migration
  def change
    create_table :hashtag_challenge_users do |t|
      t.references :hashtag_challenge, index: true
      t.string :status
      t.string :url
      t.text :json
      t.string :social_id

      t.timestamps
    end
  end
end
