class CreateTimelineItems < ActiveRecord::Migration
  def change
    create_table :timeline_items do |t|
      t.references :timelineable, index: true, polymorphic: true

      t.timestamps
    end
  end
end
