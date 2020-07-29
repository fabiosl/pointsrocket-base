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

class Graduation < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  act_as_timelineable type: :user
end
