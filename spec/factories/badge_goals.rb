# == Schema Information
#
# Table name: badge_goals
#
#  id         :integer          not null, primary key
#  badge_id   :integer
#  goal_id    :integer
#  repetition :integer
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :badge_goal do
    badge nil
    goal nil
    repetition 1
  end

end
