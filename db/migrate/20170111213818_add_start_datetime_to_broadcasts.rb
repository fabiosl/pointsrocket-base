class AddStartDatetimeToBroadcasts < ActiveRecord::Migration
  def change
    add_column :broadcasts, :start_datetime, :datetime
  end
end
