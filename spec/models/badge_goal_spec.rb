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

require 'rails_helper'

RSpec.describe BadgeGoal, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
