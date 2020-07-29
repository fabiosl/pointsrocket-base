class AddDatetimeToItems < ActiveRecord::Migration
  def change
    add_column :search_items, :datetime, :datetime
    add_index :search_items, :datetime
  end
end
