class CreateHashtagChallenges < ActiveRecord::Migration
  def change
    create_table :hashtag_challenges do |t|
      t.string :title
      t.datetime :date_start
      t.datetime :date_end
      t.integer :points
      t.text :description
      t.string :image
      t.string :slug
      t.references :badge, index: true
      t.string :hashtag
      t.text :terms
      t.float :social_interactions_multiplier

      t.timestamps
    end
  end
end
