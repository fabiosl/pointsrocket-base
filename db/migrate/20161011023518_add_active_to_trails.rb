class AddActiveToTrails < ActiveRecord::Migration
  def change
    add_column :trails, :active, :boolean, default: true
  end
end
