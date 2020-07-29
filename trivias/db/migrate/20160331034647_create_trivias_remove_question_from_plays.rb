class CreateTriviasRemoveQuestionFromPlays < ActiveRecord::Migration
  def change
    create_table :trivias_remove_question_from_plays do |t|

      t.timestamps
    end
  end
end
