# This migration comes from trivias (originally 20160331040158)
class AddOptionToTriviasAnswers < ActiveRecord::Migration
  def change
    add_reference :trivias_answers, :option, index: true
  end
end
