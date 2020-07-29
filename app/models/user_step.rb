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

class UserStep < ActiveRecord::Base
  belongs_to :user, inverse_of: :user_steps
  belongs_to :step, inverse_of: :user_steps

  after_create :graduate_finished_course

  private

  def graduate_finished_course
    course = step.chapter.course
    Graduation.create(
      user: user,
      course: course
    ) if user.finished_course?(course)
  end
end
