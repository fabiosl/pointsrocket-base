class CreateTrails < ActiveRecord::Migration
  def change
    create_table :trails do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.string :hours

      t.timestamps
    end
  end
end
