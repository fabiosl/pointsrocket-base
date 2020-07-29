class ChangeSlugFromCampaing < ActiveRecord::Migration
  def change
    change_column :campaigns, :slug, :string, uniq: true
  end
end
