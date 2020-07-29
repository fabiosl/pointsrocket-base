class CreateQuizAnswers < ActiveRecord::Migration
  def change
    create_table :quiz_answers do |t|
      t.references :user, index: true
      t.references :step, index: true
      t.boolean :bonus_added, default: false
      t.integer :bonus, default: 0

      t.timestamps
    end
  end
end
