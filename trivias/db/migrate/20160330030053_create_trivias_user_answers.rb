class CreateTriviasUserAnswers < ActiveRecord::Migration
  def change
    create_table :trivias_user_answers do |t|
      t.references :user_trivia, index: true
      t.references :question, index: true
      t.references :answer, index: true
      t.boolean :correct

      t.timestamps
    end
    add_index :trivias_user_answers, :correct
  end
end
