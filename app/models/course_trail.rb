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

class CourseTrail < ActiveRecord::Base
  belongs_to :course
  belongs_to :trail, inverse_of: :course_trails
end
