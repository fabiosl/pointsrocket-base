# == Schema Information
#
# Table name: hashtag_challenge_users
#
#  id                   :integer          not null, primary key
#  hashtag_challenge_id :integer
#  status               :string(255)
#  url                  :string(255)
#  json                 :text
#  social_id            :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  user_id              :integer
#  feedback             :text
#

class HashtagChallengeUser < ActiveRecord::Base
  include Notifiable
  include AdminNotifiable

  belongs_to :hashtag_challenge, inverse_of: :hashtag_challenge_users
  belongs_to :user, inverse_of: :hashtag_challenge_users
  has_many :comments, as: :commentable, dependent: :destroy

  validates_presence_of :status, :user, :hashtag_challenge
  validates_inclusion_of :status, :in => %w( pending declined approved ), :message => "status deve ser algum desses -> pending, declined or approved"

  scope :visible, -> { where(status: ["pending", "approved"]) }
  scope :approved, -> { where(status: "approved") }
  scope :top_engagement_posts, -> { social.sort_by(&:engagement).reverse.take(3) }
  scope :total_likes, -> { all.inject(0) { |sum, item| sum + item.total_likes } }
  scope :social, -> { where.not(social_id: nil) }

  act_as_pointable
  act_as_timelineable type: :user, update_relations: [:hashtag_challenge]

  after_update :proccess_points_and_tags
  after_update :create_timeline_item

  after_update :notify_update_status, if: :status_changed?

  def total_likes
    return 0 unless parsed_json

    metrics = parsed_json['_source']['metrics']

    likes = metrics.find { |metric| metric['name'] == 'likes' }
    likes ? likes['value'] : 0
  end

  def engagement
    return 0 unless parsed_json

    metrics = parsed_json['_source']['metrics']
    metrics.inject(0) { |sum, item| sum + item['value'] }
  end

  def parsed_json
    JSON.parse(json) if json.present?
  end

  def notify_update_status
    create_notification(status)
  end

  def get_social_network
    if social_id.present? and json.present?
      the_json = JSON.parse json

      begin
        the_json["_source"]["social_network"]
      rescue Exception => e
        ''
      end
    end
  end

  def proccess_points_and_tags
    if status == "approved"
      if hashtag_challenge.badge
        if not user.has_badge? hashtag_challenge.badge
          user.add_badge(hashtag_challenge.badge)
        end
      end

      points = get_points_for_social
      is_first_hashtag_challenge_user = hashtag_challenge.hashtag_challenge_users.where(
        user: self.user).order("created_at asc").first.id == self.id

      if is_first_hashtag_challenge_user and hashtag_challenge.points
        points += hashtag_challenge.points
      end

      if user._has_points? pointable: self
        point_obj = user.points.where(pointable: self).first

        # se o ponto atual for menor do que vai ter
        # então adiciona
        if (point_obj.value || 0) < points
          point_obj.value = points
        end

        point_obj.save!
      else
        user._add_points pointable: self, value: points
      end
    end

    if status == "declined"
      if hashtag_challenge.points
        user.points.where(pointable: self).destroy_all
      end
    end
  end

  def get_points_for_social
    if json.present? and hashtag_challenge.social_interactions_multiplier.present?
      the_json = JSON.parse json
      if the_json["_source"].present? and the_json["_source"]["metrics"].present?
        social_interactions = the_json["_source"]["metrics"].inject(0) do |memo, metric|
          if metric["value"].present?
            memo += metric["value"].to_i
          end

          memo
        end

        return (social_interactions * hashtag_challenge.social_interactions_multiplier).floor
      end
    end

    return 0
  end

  def notification_tag_list
    hashtag_challenge.tag_list
  end

  def notification_title
    if notification_options.present?
      case notification_options['type']
      when "analyzed_by_admin"
        I18n.t "notification.hashtag_challenge_user.analyzed_by_admin.#{status}", {
          social_network: get_social_network,
          challenge_title: hashtag_challenge.title
        }
      else
        I18n.t "notification.hashtag_challenge_user.publication", {
          social_network: get_social_network,
          challenge_title: hashtag_challenge.title
        }
      end
    else
      I18n.t "notification.hashtag_challenge_user.publication", {
        social_network: get_social_network,
        challenge_title: hashtag_challenge.title
      }
    end
  end

  def create_timeline_item
    if self.status == "approved"
      self.timeline_items.where(item_type: :user).first_or_create
    else
      self.timeline_items.destroy_all
    end
  end
end
