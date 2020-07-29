class AddItemTypeToTimelineItems < ActiveRecord::Migration
  def change
    add_column :timeline_items, :item_type, :string, index: true
  end
end
