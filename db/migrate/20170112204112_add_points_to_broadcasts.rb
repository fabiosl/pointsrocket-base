class AddPointsToBroadcasts < ActiveRecord::Migration
  def change
    add_column :broadcasts, :points, :integer
  end
end
