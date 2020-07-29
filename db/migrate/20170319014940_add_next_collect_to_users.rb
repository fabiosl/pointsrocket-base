class AddNextCollectToUsers < ActiveRecord::Migration
  def change
    add_column :users, :next_youtube_collect, :datetime
    add_column :users, :next_facebook_collect, :datetime
    add_column :users, :next_instagram_collect, :datetime
  end
end
