class CreateTriviasUserTrivia < ActiveRecord::Migration
  def change
    create_table :trivias_user_trivia do |t|
      t.references :user, index: true
      t.references :trivia, index: true

      t.timestamps
    end
  end
end
