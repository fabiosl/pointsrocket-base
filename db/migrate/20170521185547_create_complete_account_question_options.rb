class CreateCompleteAccountQuestionOptions < ActiveRecord::Migration
  def change
    create_table :complete_account_question_options do |t|
      t.references :complete_account_question, index: {
        name: 'index_caqo_on_complete_account_question_id'
      }
      t.string :name

      t.timestamps
    end
  end
end
