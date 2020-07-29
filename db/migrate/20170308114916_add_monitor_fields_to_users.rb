class AddMonitorFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :youtube_channel_id_to_monitor, :text
    add_column :users, :facebook_page_id_to_monitor, :text
  end
end
