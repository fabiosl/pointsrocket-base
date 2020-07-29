# == Schema Information
#
# Table name: graduations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  course_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :graduation do
    user nil
course nil
  end

end
