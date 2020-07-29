# == Schema Information
#
# Table name: quiz_answers
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  step_id     :integer
#  bonus_added :boolean          default(FALSE)
#  bonus       :integer          default(0)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe QuizAnswer, type: :model do
  describe 'validation' do
      [:user, :step].each do |attribute|
        it "validates presence of #{attribute}" do
          attributes = {}
          attributes[attribute] = nil
          @quiz_answer = build(:quiz_answer, attributes)
          @quiz_answer.valid?
          expect(@quiz_answer.errors).to have_key(attribute)
        end
      end
    end
end
