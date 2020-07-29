class CreateStepQuestions < ActiveRecord::Migration
  def change
    create_table :step_questions do |t|
      t.string  :question
      t.string  :hint
      t.integer :score

      t.integer :step_id
      t.timestamps
    end
  end
end
