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

class QuizAnswer < ActiveRecord::Base
  belongs_to :user
  belongs_to :step

  validates_presence_of :user, :step
end
