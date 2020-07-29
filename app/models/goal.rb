# == Schema Information
#
# Table name: goals
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Goal < ActiveRecord::Base
  has_many :badge_goals, inverse_of: :goal, dependent: :destroy
  has_many :badges, through: :badge_goals

  acts_as_taggable

  accepts_nested_attributes_for :badge_goals, :allow_destroy => true
end
