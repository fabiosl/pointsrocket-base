class RenameAnswerToOption < ActiveRecord::Migration
  def change
    rename_column :trivias_user_answers, :answer_id, :option_id
  end
end
