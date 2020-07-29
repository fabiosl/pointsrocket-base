class AddContentToCoinUsers < ActiveRecord::Migration
  def change
    add_column :coin_users, :content, :text
  end
end
