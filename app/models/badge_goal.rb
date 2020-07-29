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

class BadgeGoal < ActiveRecord::Base
  belongs_to :badge, inverse_of: :badge_goals
  belongs_to :goal, inverse_of: :badge_goals
end
