class AddAvailableCoinsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :available_coins, :integer, default: 0
  end
end
