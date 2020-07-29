class CreateTriviasTrivia < ActiveRecord::Migration
  def change
    create_table :trivias_trivia do |t|
      t.string :title
      t.string :slug
      t.datetime :published_date

      t.timestamps
    end
  end
end
