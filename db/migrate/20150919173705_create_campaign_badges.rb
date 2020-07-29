class CreateCampaignBadges < ActiveRecord::Migration
  def change
    create_table :campaign_badges do |t|
      t.references :campaign, index: true
      t.references :badge, index: true

      t.timestamps
    end
  end
end
