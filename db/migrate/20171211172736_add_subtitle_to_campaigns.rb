class AddSubtitleToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :subtitle, :string, default: ''
  end
end
