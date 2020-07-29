class CreateStepQuestionOptions < ActiveRecord::Migration
  def change
    create_table :step_question_options do |t|
      t.string  :content
      t.boolean :correct, default: false

      t.integer :step_question_id

      t.timestamps
    end
  end
end
