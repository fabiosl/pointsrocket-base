class CreateTriviasQuestions < ActiveRecord::Migration
  def change
    create_table :trivias_questions do |t|
      t.string :name
      t.string :slug
      t.references :trivia, index: true

      t.timestamps
    end
  end
end
