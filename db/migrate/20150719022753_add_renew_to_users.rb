class AddRenewToUsers < ActiveRecord::Migration
  def change
    add_column :users, :renew, :boolean, default: true
  end
end
