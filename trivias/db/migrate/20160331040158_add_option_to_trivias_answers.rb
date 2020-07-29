class AddOptionToTriviasAnswers < ActiveRecord::Migration
  def change
    add_reference :trivias_answers, :option, index: true
  end
end
