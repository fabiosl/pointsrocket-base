class CreateTriviasAnswers < ActiveRecord::Migration
  def change
    create_table :trivias_answers do |t|
      t.references :question, index: true
      t.references :play, index: true
      t.boolean :correct
      t.integer :seconds_took

      t.timestamps
    end
    add_index :trivias_answers, :correct
  end
end
