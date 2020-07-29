class CreateBadges < ActiveRecord::Migration
  def change
    create_table :badges do |t|
      t.references :badgeable, index: true, polymorphic: true
      t.string :name
      t.string :slug
      t.integer :badge_points

      t.timestamps
    end
  end
end
