class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.string :title
      t.datetime :date_start
      t.datetime :date_end
      t.integer :points
      t.text :description
      t.string :image
      t.string :slug

      t.timestamps
    end
  end
end
