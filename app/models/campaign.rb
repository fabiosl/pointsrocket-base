# == Schema Information
#
# Table name: campaigns
#
#  id                  :integer          not null, primary key
#  title               :string(255)
#  description         :text
#  start_date          :datetime
#  end_date            :datetime
#  slug                :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  image_file_name     :string(255)
#  image_content_type  :string(255)
#  image_file_size     :integer
#  image_updated_at    :datetime
#  redeem_points       :integer
#  max_redeems         :integer
#  withdrawable_points :integer          default(0)
#  subtitle            :string(255)      default("")
#

class Campaign < ActiveRecord::Base
  include NotifiableComment

  # paperclip
  has_attached_file :image, :styles => {
    :campaign_index => "500x150#",
    :thumb => "200x75",
    :redeem => "200x200",
  }, :default_url => ":style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  attr_accessor :delete_image
  before_validation { image.clear if delete_image == '1' }

  scope :not_redeemable, -> { where(redeem_points: nil) }

  just_define_datetime_picker :start_date
  just_define_datetime_picker :end_date

  has_many :campaign_badges, dependent: :destroy
  has_many :badges, through: :campaign_badges
  accepts_nested_attributes_for :campaign_badges, :allow_destroy => true

  has_many :campaign_users, dependent: :destroy
  has_many :users, through: :campaign_users
  has_many :comments, as: :commentable, dependent: :destroy

  acts_as_taggable
  act_as_searchable
  act_as_timelineable type: :admin

  validates_presence_of :title, :description, :image
  validates_presence_of :start_date, :end_date, unless: :redeem_points?
  validates_presence_of :max_redeems, :if => :redeem_points?


  def search_content
    "#{self.title} #{self.description}"
  end

  # slug
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  def has_complete_campaign? user
    completed = true
    self.badges.each do |badge|
      if not badge.users.where(id: user.id).any?
        completed = false
      end
    end

    completed
  end

  def able_to_redeem_by_points? user
    redeem_points.present? and user.sum_points >= redeem_points
  end

  def able_to_redeem_by_badges? user
    badges.find do |b|
      not user.has_badge? b
    end.nil?
  end

  def available_redeems
    [0, max_redeems - CampaignUser.where(campaign_id: self.id).count].max
  end

  def able_to_redeem_by_limit?
    by_limit = max_redeems.present? and CampaignUser.where(campaign_id: self.id).count < max_redeems
  end

  def able_to_redeem? user
    able_to_redeem_by_points?(user) and able_to_redeem_by_badges?(user) and able_to_redeem_by_limit?
  end

  def is_redeemable?
    redeem_points.present?
  end

  def image_timeline
    image.url(:campaign_index)
  end
end
