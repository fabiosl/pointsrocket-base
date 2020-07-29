class AddDescriptionToCampaignBadges < ActiveRecord::Migration
  def change
    add_column :campaign_badges, :description, :string
  end
end
