class CreateCategoryLinks < ActiveRecord::Migration
  def change
    create_table :category_links do |t|
      t.references :category, index: true
      t.references :categoriable, index: true, polymorphic: true

      t.timestamps
    end
  end
end
