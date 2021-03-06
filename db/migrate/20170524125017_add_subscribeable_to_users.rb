class AddSubscribeableToUsers < ActiveRecord::Migration
  def change
    add_column :users, :unsubscribe_token, :string
    add_column :users, :subscribe, :boolean
    add_index :users, :unsubscribe_token, :unique => true
  end
end
