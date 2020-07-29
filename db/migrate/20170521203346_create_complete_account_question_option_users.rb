class CreateCompleteAccountQuestionOptionUsers < ActiveRecord::Migration
  def change
    create_table :complete_account_question_option_users do |t|
      t.references :complete_account_question_option, index: {
        name: 'index_caqo_on_caqo_id'
      }
      t.references :user, index: {
        name: 'index_user_on_caqo_id'
      }

      t.timestamps
    end
  end
end
