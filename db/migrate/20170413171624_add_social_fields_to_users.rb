class AddSocialFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_page_name_to_monitor, :string
    add_column :users, :facebook_page_picture_to_monitor, :string
    add_column :users, :youtube_channel_name_to_monitor, :string
    add_column :users, :youtube_channel_picture_to_monitor, :string
  end
end
