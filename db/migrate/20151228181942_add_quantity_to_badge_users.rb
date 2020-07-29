class AddQuantityToBadgeUsers < ActiveRecord::Migration
  def change
    add_column :badge_users, :quantity, :integer, default: 1
  end
end
