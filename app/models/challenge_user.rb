# == Schema Information
#
# Table name: challenge_users
#
#  id           :integer          not null, primary key
#  challenge_id :integer
#  user_id      :integer
#  status       :string(255)
#  feedback     :text
#  url          :string(255)
#  description  :text
#  created_at   :datetime
#  updated_at   :datetime
#  json         :text
#  social_id    :string(255)
#  file         :string(255)
#

class ChallengeUser < ActiveRecord::Base
  include AdminNotifiable
  include Notifiable

  # to do, remove this from interface
  # set this to true if you want to check accept_terms
  attr_accessor :check_terms

  # will be required if check_terms is present
  attr_accessor :accept_terms

  STATUSES = %w(pending declined approved)

  belongs_to :challenge, inverse_of: :challenge_users
  belongs_to :user, inverse_of: :challenge_users
  has_many :comments, as: :commentable, dependent: :destroy

  mount_uploader :file, FileUploader

  validates_presence_of :status, :user, :challenge
  validates_presence_of :description, if: -> { file.blank? }
  validates_inclusion_of :status, :in => STATUSES, :message => "status deve ser algum desses -> pending, declined or approved"

  scope :visible, -> { where(status: ["pending", "approved"]) }

  # act_as_notificable
  act_as_pointable
  act_as_timelineable type: :user, update_relations: [:challenge]

  after_update :notify_update_status, if: :status_changed?

  after_update :check_and_apply_tag
  after_update :create_timeline_item


  STATUSES.each do |status_name|
    define_method "#{status_name}?" do
      status == status_name
    end
  end


  def has_image_file?
    return file.content_type.split('/')[0] == 'image' if file.present?
    false
  end

  def notify_update_status
    create_notification(status)
    domain = Domain.find_by(subdomain: Apartment::Tenant.current)
    ChallengeUserApprovedMailWorker.perform_async(domain.id, user.id, id)
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

  def check_and_apply_tag
    if status == "approved"
      if challenge.badge
        if not user.has_badge? challenge.badge
          user.add_badge(challenge.badge)
        end
      end

      points = 0

      if challenge.points
        points += challenge.points
      end

      if user._has_points? pointable: self
        point_obj = user.points.where(pointable: self).first
        point_obj.value = points
        point_obj.save!
      else
        user._add_points pointable: self, value: points
      end
    end

    if status == "declined"
      if challenge.points
        user.points.where(pointable: self).destroy_all
      end
    end
  end

  def notification_tag_list
    challenge.tag_list
  end

  def notification_title
    if notification_options.present?
      case notification_options['type']
      when "analyzed_by_admin"
        I18n.t "notification.challenge_user.analyzed_by_admin.#{status}", {
          challenge_title: challenge.title
        }
      else
        I18n.t "notification.challenge_user.submission.#{notify_event}", {
          challenge_title: challenge.title
        }
      end
    else
      I18n.t "notification.challenge_user.submission.#{notify_event}", {
        challenge_title: challenge.title
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
