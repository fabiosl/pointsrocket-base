class AddRendemptionsFieldsToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :rendemptions_points, :integer
    add_column :campaigns, :max_rendemptions, :integer
  end
end
