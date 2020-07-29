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

FactoryGirl.define do
  factory :course_trail do
    course nil
trail nil
  end

end
