class ChangeRendemptionsFieldsToCampaigns < ActiveRecord::Migration
  def change
    remove_column :campaigns, :rendemptions_points
    remove_column :campaigns, :max_rendemptions
    add_column :campaigns, :redeem_points, :integer
    add_column :campaigns, :max_redeems, :integer
  end
end
