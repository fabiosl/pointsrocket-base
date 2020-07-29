# == Schema Information
#
# Table name: trails
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  slug        :string(255)
#  hours       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  position    :integer
#  age_group   :string(255)
#  video_url   :string(255)
#  active      :boolean          default(TRUE)
#

class Trail < ActiveRecord::Base
  default_scope { order('position DESC') }

  acts_as_taggable

  has_many :course_trails, inverse_of: :trail
  has_many :courses, through: :course_trails

  has_many :category_links, as: :categoriable
  has_many :categories, through: :category_links, as: :categoriable

  accepts_nested_attributes_for :course_trails, :allow_destroy => true
  accepts_nested_attributes_for :category_links, :allow_destroy => true

  scope :active, -> { where(active: true) }
end
