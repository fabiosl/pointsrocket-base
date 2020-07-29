class AddScoreAddedToQuestionAnswer < ActiveRecord::Migration
  def change
    add_column :question_answers, :score_added, :boolean, default: false
  end
end
