class CreateTriviasPlays < ActiveRecord::Migration
  def change
    create_table :trivias_plays do |t|
      t.references :user, index: true
      t.text :questions

      t.timestamps
    end
  end
end
