class AddPinnedToTimelineItems < ActiveRecord::Migration
  def change
    add_column :timeline_items, :pinned, :boolean, default: false
  end
end
