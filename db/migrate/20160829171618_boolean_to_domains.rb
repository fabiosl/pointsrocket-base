class BooleanToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :dashboard_enabled, :boolean, default: true
    add_column :domains, :courses_enabled, :boolean, default: true
    add_column :domains, :forum_enabled, :boolean, default: true
  end
end
