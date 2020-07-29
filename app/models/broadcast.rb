# == Schema Information
#
# Table name: broadcasts
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  url           :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  schedule_time :datetime
#  description   :text
#  badge_id      :integer
#  points        :integer
#  slug          :string(255)
#

class Broadcast < ActiveRecord::Base
  act_as_badgeable
  act_as_searchable
  acts_as_taggable
  act_as_timelineable type: :admin

  has_many :visualizations
  has_many :users, through: :visualizations

  has_many :comments, as: :commentable, dependent: :destroy

  # slug
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  def schedule_time_str
    return 'No schedule time' unless schedule_time

    schedule_time.strftime("%d/%m #{I18n.t('views.general.time_at')} %Hh%M")
  end

  def badge_name
    badge ? badge.name : "#{I18n.t('views.general.no_medals')}"
  end

  def status
    return 'upcoming' if status_upcoming?
    return 'live' if status_live?
    return 'complete' if status_complete?
  end

  def image_url(size = :standard)
    case size
    when :thumb
      "https://img.youtube.com/vi/#{video_id}/default.jpg"
    else
      "https://img.youtube.com/vi/#{video_id}/sddefault.jpg"
    end
  end

  def video_id
    Youtube::DataHelpers.video_id(url)
  end

  def done_by_user?(user)
    user.broadcasts.include?(self)
  end

  def as_json(options={})
    options[:methods] = [:status, :video_id, :visualizations]
    super
  end

  private

  def status_live?
    time_now_in_seconds = Time.zone.now.to_i
    schedule_time_in_seconds = schedule_time.to_i

    schedule_time_in_seconds < time_now_in_seconds &&
    schedule_time_remaining_hours <= 60
  end

  def status_complete?
    schedule_time_remaining_hours > 60
  end

  def status_upcoming?
    schedule_time.to_i > Time.zone.now.to_i
  end

  def schedule_time_remaining_hours
    (Time.zone.now.to_i - schedule_time.to_i) / 60.0
  end
end
