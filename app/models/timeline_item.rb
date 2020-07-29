# == Schema Information
#
# Table name: timeline_items
#
#  id                :integer          not null, primary key
#  timelineable_id   :integer
#  timelineable_type :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  item_type         :string(255)
#  visible           :boolean          default(TRUE)
#  pinned            :boolean          default(FALSE)
#

class TimelineItem < ActiveRecord::Base
  belongs_to :timelineable, polymorphic: true

  validates_presence_of :item_type

  after_save :send_to_index
  before_destroy :destroy_from_index

  PROFILE_TIMELINE_ITEMS = [
    'BadgeUser',
    'CampaignUser',
    'CoinUser',
    'ChallengeUser',
    'EmployeeAdvocacyPost',
    'EmployeeAdvocacyShare',
    'Graduation',
    'HashtagChallengeUser',
    'Post',
    'Question'
  ]

  EXCLUDE_DEFAULT_TIMELINE_ITEMS = [
    'Badge',
    'BadgeUser',
    'Broadcast',
    'CoinUser',
    'Challenge',
    'EmployeeAdvocacyShare',
    'Graduation',
    'HashtagChallenge'
  ]

  scope :visible, -> { where.not(visible: false) }
  scope :not_visible, -> { where(visible: false) }
  scope :pinned, -> { where(pinned: true) }
  scope :not_pinned, -> { where(pinned: false) }
  scope :default, -> { where.not(timelineable_type: EXCLUDE_DEFAULT_TIMELINE_ITEMS) }
  scope :profile, -> { where(timelineable_type: PROFILE_TIMELINE_ITEMS) }

  def es_id
    "#{Apartment::Tenant.current}_timeline_item_#{self.id}"
  end

  def destroy_from_index
    # HTTParty.delete "#{ENV['ES_URL']}/#{ENV['ES_INDEX']}/timeline/#{es_id}"
  end

  def send_to_index
    # include ActionView::Helpers::DateHelper
    # include ActionView::Helpers::TextHelper

    # if persisted?
    #   json = Rabl::Renderer.new(
    #     'api/timeline_items/timeline_item',
    #     self,
    #     {
    #       :view_path => 'app/views',
    #     }).render

    #   HTTParty.put(
    #     "#{ENV['ES_URL']}/#{ENV['ES_INDEX']}/timeline/#{es_id}",
    #     {
    #       headers: {
    #         "Content-Type" => "application/json"
    #       },
    #       body: {
    #         json: json,
    #         timelineable_id: timelineable_id,
    #         timelineable_type: timelineable_type,
    #         tenant: Apartment::Tenant.current,
    #         created_time: self.timelineable.created_at.strftime("%Y-%m-%d %H:%M:%S")
    #       }.to_json
    #     }
    #   )
    # end


  end
end
