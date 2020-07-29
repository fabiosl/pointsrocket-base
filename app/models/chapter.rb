# == Schema Information
#
# Table name: chapters
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  course_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#  slug        :string(255)
#  position    :integer
#

class Chapter < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true

  has_many :steps, inverse_of: :chapter, dependent: :destroy
  belongs_to :course, inverse_of: :chapters

  accepts_nested_attributes_for :steps, :allow_destroy => true
  act_as_badgeable

  scope :by_position, -> { order('position asc') }

  act_as_searchable

  def search_content
    "#{self.name} #{self.description}"
  end

  def ordered_steps
    steps.by_position
  end

  # slug
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  def get_quizes
    self.steps.where(step_type: 'Quiz')
  end

  def points
    self.steps.points
  end

end
