class AddNextSocialNetworksAdvocacyCollectToUsers < ActiveRecord::Migration
  def change
    add_column :users, :next_twitter_advocacy_collect, :datetime
    add_column :users, :next_facebook_advocacy_collect, :datetime
  end
end
