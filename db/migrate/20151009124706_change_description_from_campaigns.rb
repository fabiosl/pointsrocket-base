class ChangeDescriptionFromCampaigns < ActiveRecord::Migration
  def change
    change_column :campaigns, :description, :text
  end
end
