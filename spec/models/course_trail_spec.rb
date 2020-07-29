# == Schema Information
#
# Table name: course_trails
#
#  id         :integer          not null, primary key
#  course_id  :integer
#  trail_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe CourseTrail, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
