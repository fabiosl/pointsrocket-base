# This migration comes from search (originally 20160421150150)
class CreateSearchItems < ActiveRecord::Migration
  def change
    create_table :search_items do |t|
      t.references :searchable, polymorphic: true, index: true
      t.text :content

      t.timestamps
    end
    add_index :search_items, :content
  end
end
