# == Schema Information
#
# Table name: badges
#
#  id                  :integer          not null, primary key
#  badgeable_id        :integer
#  badgeable_type      :string(255)
#  name                :string(255)
#  slug                :string(255)
#  badge_points        :integer
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  category            :string(255)
#  hint                :string(255)
#  badge_type          :string(255)
#

class Badge < ActiveRecord::Base
  validates_presence_of :name, :badge_points, :badge_type
  validates :badge_type, inclusion: { in: %w(simple reusable), message: "%{value} não é um tipo válido"}

  belongs_to :badgeable, polymorphic: true

  acts_as_taggable

  has_many :badge_users, dependent: :destroy
  has_many :users, through: :badge_users
  has_many :points, dependent: :destroy
  has_many :badge_goals, inverse_of: :badge, dependent: :destroy
  has_many :goals, through: :badge_goals

  has_many :campaign_badges, dependent: :destroy
  has_many :campaigns, through: :campaign_badges
  has_many :comments, as: :commentable, dependent: :destroy

  act_as_pointable
  act_as_timelineable type: :admin

  has_attached_file :avatar, :styles => { :s100x109 => "100x109#" }, :default_url => ":style/default_badge.png"
  validates_attachment_content_type :avatar, content_type: ['image/jpeg', 'image/png']

  # slug
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  def avatar_timeline
    self.avatar.url(:s100x109)
  end

  def done_by_user?(user)
    user.has_badge?(self)
  end
end
