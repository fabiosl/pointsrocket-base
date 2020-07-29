class CreateBadgeGoals < ActiveRecord::Migration
  def change
    create_table :badge_goals do |t|
      t.references :badge, index: true
      t.references :goal, index: true
      t.integer :repetition

      t.timestamps
    end
  end
end
