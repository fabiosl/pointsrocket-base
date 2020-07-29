class CreateCompleteAccountQuestions < ActiveRecord::Migration
  def change
    create_table :complete_account_questions do |t|
      t.string :title

      t.timestamps
    end
  end
end
