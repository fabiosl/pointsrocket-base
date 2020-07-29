class CreateHowToPointItems < ActiveRecord::Migration
  def change
    create_table :how_to_point_items do |t|
      t.integer :points
      t.string :description
      t.string :section
      t.references :domain, index: true

      t.timestamps
    end
  end
end
