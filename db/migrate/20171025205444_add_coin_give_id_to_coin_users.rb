class AddCoinGiveIdToCoinUsers < ActiveRecord::Migration
  def change
    add_column :coin_users, :coin_give_id, :integer
  end
end
