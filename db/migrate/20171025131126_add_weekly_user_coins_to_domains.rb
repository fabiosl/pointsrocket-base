class AddWeeklyUserCoinsToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :weekly_user_coins, :integer, default: 0
  end
end
