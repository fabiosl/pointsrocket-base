class AddDescriptionToBroadcasts < ActiveRecord::Migration
  def change
    add_column :broadcasts, :description, :text
  end
end
