class CreateQuestionAnswers < ActiveRecord::Migration
  def change
    create_table :question_answers do |t|
      t.references :user, index: true
      t.references :step_question, index: true
      t.references :step_question_option, index: true

      t.timestamps
    end
  end
end
