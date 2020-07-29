# == Schema Information
#
# Table name: challenges
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  date_start     :datetime
#  date_end       :datetime
#  points         :integer
#  description    :text
#  image          :string(255)
#  slug           :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  badge_id       :integer
#  terms          :text
#  privacy        :string(255)      default("all")
#  recommendation :text
#

class Challenge < ActiveRecord::Base
  include ImageValidatable
  include NotifiableComment

  PRIVACY_TYPES = %w(all admin)

  belongs_to :badge
  has_many :challenge_users, inverse_of: :challenge, dependent: :destroy

  has_many :comments, as: :commentable, dependent: :destroy

  validates_presence_of :title, :slug, :date_start, :date_end
  validates_inclusion_of :privacy, in: PRIVACY_TYPES
  mount_uploader :image, ImageUploader

  # slug
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  acts_as_taggable
  act_as_searchable
  act_as_timelineable type: :admin

  def validate
  end

  def formatted_date_start
    date_start.strftime("%d/%m/%Y")
  end

  def formatted_date_end
    date_end.strftime("%d/%m/%Y")
  end

  def full_image
    image.url
  end

  def timeline_image
    # image.url(:medium)
    image.url
  end

  def user_ids_visible
    challenge_users.visible.group("user_id")
  end

  def has_passed?
    self.date_end and Time.now > self.date_end
  end

  def done_by_user?(user)
    user.challenge_participating?(self)
  end
end
