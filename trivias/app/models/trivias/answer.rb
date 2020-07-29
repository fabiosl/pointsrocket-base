# == Schema Information
#
# Table name: trivias_answers
#
#  id           :integer          not null, primary key
#  question_id  :integer
#  play_id      :integer
#  correct      :boolean
#  seconds_took :integer
#  created_at   :datetime
#  updated_at   :datetime
#  option_id    :integer
#

module Trivias
  class Answer < ActiveRecord::Base
    belongs_to :question, inverse_of: :answers
    belongs_to :play, inverse_of: :answers
    belongs_to :option

    before_save :set_correct

    def set_correct
      if self.question.present?
        correct_options = self.question.options.correct

        if correct_options.any?
          self.correct = correct_options.where(id: self.option.id).any?
        end
      end

      self
    end
  end
end
