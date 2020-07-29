# This migration comes from search (originally 20160421174047)
class AddDatetimeToItems < ActiveRecord::Migration
  def change
    add_column :search_items, :datetime, :datetime
    add_index :search_items, :datetime
  end
end
