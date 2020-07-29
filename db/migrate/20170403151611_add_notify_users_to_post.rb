class AddNotifyUsersToPost < ActiveRecord::Migration
  def change
    add_column :posts, :notify_users, :boolean, default: false
  end
end
