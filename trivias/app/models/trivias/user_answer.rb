# == Schema Information
#
# Table name: trivias_user_answers
#
#  id             :integer          not null, primary key
#  user_trivia_id :integer
#  question_id    :integer
#  option_id      :integer
#  correct        :boolean
#  created_at     :datetime
#  updated_at     :datetime
#

module Trivias
  class UserAnswer < ActiveRecord::Base
    belongs_to :user_trivia, inverse_of: :user_answers
    belongs_to :question
    belongs_to :option

    before_save :set_correct

    def set_correct
      correct_options = self.question.options.correct

      if correct_options.any?
        self.correct = correct_options.where(id: self.option.id).any?
      end

      self
    end
  end
end
