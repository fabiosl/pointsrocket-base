class AddPositionToTrails < ActiveRecord::Migration
  def change
    add_column :trails, :position, :integer
  end
end
