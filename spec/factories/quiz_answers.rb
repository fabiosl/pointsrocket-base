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

FactoryGirl.define do
  factory :quiz_answer do
    user
    step
    bonus_added false
    bonus 1
  end
end
