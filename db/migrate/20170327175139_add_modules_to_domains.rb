class AddModulesToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :challenges_enabled, :boolean, default: true
    add_column :domains, :hashtag_challenges_enabled, :boolean, default: true
    add_column :domains, :broadcasts_enabled, :boolean, default: true
    add_column :domains, :campaigns_enabled, :boolean, default: true
  end
end
