# == Schema Information
#
# Table name: courses
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :text
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  slug                :string(255)
#  comming_soon        :boolean          default(FALSE)
#  preview_url         :string(255)
#  active              :boolean          default(TRUE)
#  monitor_html        :text
#

class Course < ActiveRecord::Base
  attr_accessor :finish_badge_image
  attr_accessor :finish_badge_points
  attr_accessor :finish_badge_id
  attr_accessor :delete_finish_badge_points

  after_save :update_finished_course_badge_image
  after_save :delete_finish_badge_points_after_save

  validates :name, presence: true
  validates :slug, presence: true
  validates :avatar, presence: true
  validates :description, presence: true

  acts_as_taggable

  has_attached_file :avatar, :styles => { :large => "512x512", :trilha_preview => "512x150#", small: "80x80", medium: "150x150" }
  validates_attachment_content_type :avatar, content_type: ['image/jpeg', 'image/png']
  
  act_as_badgeable
  act_as_timelineable type: :admin

  has_many :chapters, inverse_of: :course, dependent: :destroy
  has_many :steps, through: :chapters
  has_many :questions, through: :steps
  has_many :comments, as: :commentable, dependent: :destroy

  accepts_nested_attributes_for :chapters, :allow_destroy => true

  scope :name_asc, -> { order('name ASC') }
  scope :active, -> { where(active: true) }
  scope :comming_soon, -> { where(comming_soon: true) }

  def ordered_chapters
    chapters.by_position
  end

  act_as_searchable

  def search_content
    "#{self.name} #{self.description}"
  end

  def delete_finish_badge_points_after_save
    if self.delete_finish_badge_points and self.finish_badge_id.present?
      course_badge = Badge.find self.finish_badge_id
      course_badge.destroy
    end
  end

  def update_finished_course_badge_image
    if self.finish_badge_image.present?
      course_badge = nil

      if self.finish_badge_id.present?
        course_badge = Badge.find self.finish_badge_id
      end

      if not course_badge.present?
        course_badge = Badge.create!({
          badgeable: self,
          avatar: self.finish_badge_image,
          name: "Curso de #{self.name} finalizado",
          hint: "Finalize o curso #{self.name} para conquistar esta medalha",
          badge_type: "simple",
          badge_points: 0
        })
      else
        course_badge.name = "Curso de #{self.name} finalizado"
        course_badge.hint = "Finalize o curso #{self.name} para conquistar esta medalha"
      end

      if not self.finish_badge_id.present?
        self.finish_badge_id = course_badge.id
      end

      course_badge.avatar = self.finish_badge_image if self.finish_badge_image.present?
      course_badge.category = self.name

      if self.finish_badge_points.present?
        course_badge.badge_points = self.finish_badge_points
      end

      course_badge.save
    end
  end

  def current_finished_course_badge
    Badge.find_by_name_and_badgeable_type("Curso de #{self.name} finalizado", "Course")
  end

  # slug
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  def get_quizes
    self.steps.where(step_type: 'Quiz')
  end

  def points
    to_add = 0

    if self.current_finished_course_badge.present?
      to_add += self.current_finished_course_badge.badge_points
    end

    self.steps.points + to_add
  end

  def avatar_timeline
    avatar.url(:small)
  end

  def users_finished
    User.all.select { |user| user.finished_course?(self) }
  end
  
  def users_finished_count
    users_finished.size
  end


  def done_by_user?(user)
    user.finished_course?(self)
  end

end
