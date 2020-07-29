class AddBadgeToBroadcasts < ActiveRecord::Migration
  def change
    add_reference :broadcasts, :badge, index: true
  end
end
