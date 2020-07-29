# == Schema Information
#
# Table name: hashtag_challenges
#
#  id                             :integer          not null, primary key
#  title                          :string(255)
#  date_start                     :datetime
#  date_end                       :datetime
#  points                         :integer
#  description                    :text
#  image                          :string(255)
#  slug                           :string(255)
#  badge_id                       :integer
#  hashtag                        :string(255)
#  terms                          :text
#  social_interactions_multiplier :float
#  created_at                     :datetime
#  updated_at                     :datetime
#

class HashtagChallenge < ActiveRecord::Base
  include ImageValidatable
  include NotifiableComment
  
  belongs_to :badge
  has_many :hashtag_challenge_users, inverse_of: :hashtag_challenge, dependent: :destroy

  has_many :comments, as: :commentable, dependent: :destroy

  validates_presence_of :title, :slug, :hashtag, :date_start, :date_end
  mount_uploader :image, ImageUploader

  # slug
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  acts_as_taggable
  act_as_searchable
  act_as_timelineable type: :admin

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
    image.url(:medium)
  end

  def user_ids_visible
    hashtag_challenge_users.visible.group("user_id")
  end

  def has_passed?
    self.date_end and Time.now > self.date_end
  end

  def get_hashtag_challenge_user_for opt={}
    user = opt[:user]
    provider = opt[:provider]

    self.hashtag_challenge_users.where(user: user).select do |hashtag_challenge_user|
      if not hashtag_challenge_user.json.nil?
        json = JSON.parse hashtag_challenge_user.json
        json["_source"]["social_network"].to_sym == provider.to_sym
      else
        false
      end
    end
  end

  def done_by_user?(user)
    user.hashtag_challenge_approved?(self)
  end
end
