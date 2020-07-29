class AddVisibleToTimelineItems < ActiveRecord::Migration
  def change
    add_column :timeline_items, :visible, :boolean, default: true
  end
end
