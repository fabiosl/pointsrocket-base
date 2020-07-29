# == Schema Information
#
# Table name: user_steps
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  step_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :user_step do
    user
    step
  end

end
