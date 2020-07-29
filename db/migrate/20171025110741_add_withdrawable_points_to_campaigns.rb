class AddWithdrawablePointsToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :withdrawable_points, :integer, default: 0
  end
end
