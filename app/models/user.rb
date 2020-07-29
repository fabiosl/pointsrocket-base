# == Schema Information
#
# Table name: users
#
#  id                                 :integer          not null, primary key
#  email                              :string(255)      default(""), not null
#  encrypted_password                 :string(255)      default(""), not null
#  reset_password_token               :string(255)
#  reset_password_sent_at             :datetime
#  remember_created_at                :datetime
#  sign_in_count                      :integer          default(0), not null
#  current_sign_in_at                 :datetime
#  last_sign_in_at                    :datetime
#  current_sign_in_ip                 :string(255)
#  last_sign_in_ip                    :string(255)
#  created_at                         :datetime
#  updated_at                         :datetime
#  provider                           :string(255)
#  uid                                :string(255)
#  name                               :string(255)
#  needs_edit                         :boolean          default(TRUE)
#  avatar_file_name                   :string(255)
#  avatar_content_type                :string(255)
#  avatar_file_size                   :integer
#  avatar_updated_at                  :datetime
#  plan_id                            :integer
#  expires_in                         :datetime
#  website                            :string(255)
#  bio                                :text
#  location                           :string(255)
#  username                           :string(255)
#  lang                               :string(255)
#  timezone                           :string(255)
#  country                            :string(255)
#  see_sensitive_media                :boolean          default(FALSE)
#  mark_sensitive_media               :boolean          default(FALSE)
#  facebook_json                      :text
#  sash_id                            :integer
#  level                              :integer          default(0)
#  ranking_position                   :integer
#  indicator_id                       :integer
#  cpf                                :string(255)
#  phone                              :string(255)
#  birthdate                          :datetime
#  moip_code                          :string(255)
#  has_submited_payment_form          :boolean          default(FALSE)
#  master                             :boolean          default(FALSE)
#  renew                              :boolean          default(TRUE)
#  expires_at                         :datetime
#  moip_signature_code                :string(255)
#  signature_status                   :string(255)
#  cancel_reason                      :string(255)
#  admin                              :boolean          default(FALSE)
#  mailed_welcome                     :boolean          default(FALSE)
#  sum_points                         :integer          default(0)
#  created_in_dash                    :boolean          default(FALSE)
#  voucher                            :string(255)
#  can_manage_all_domains             :boolean          default(FALSE)
#  locale                             :string(255)
#  youtube_channel_id_to_monitor      :text
#  facebook_page_id_to_monitor        :text
#  registration_complete              :boolean          default(FALSE)
#  next_youtube_collect               :datetime
#  next_facebook_collect              :datetime
#  next_instagram_collect             :datetime
#  last_access                        :datetime
#  facebook_page_name_to_monitor      :string(255)
#  facebook_page_picture_to_monitor   :string(255)
#  youtube_channel_name_to_monitor    :string(255)
#  youtube_channel_picture_to_monitor :string(255)
#  unsubscribe_token                  :string(255)
#  subscribe                          :boolean          default(TRUE)
#  has_sent_access_token_expired_mail :boolean          default(FALSE)
#  token_login                        :string(255)
#  must_alter_password                :boolean
#  next_twitter_advocacy_collect      :datetime
#  next_facebook_advocacy_collect     :datetime
#  available_coins                    :integer          default(0)
#

class VoucherFrancheeseValidator < ActiveModel::Validator
  def validate(record)
    if record.voucher.present?
      if not Franchisee.where(token: record.voucher).any?
        record.errors[:voucher] << "não encontrado"
      end
    end
  end
end


class User < ActiveRecord::Base

  class OnlyInvitedException < Exception; end
  class NoIdentityFound < Exception ; end

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  INTEREST_CATEGORIES = %w(Makeup HairColor SkinCare HairStyle Fragances)
  INTEREST_TOPICS = %w(Trends BrandsAndProducts Events Fashion)

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  providers = [:instagram, :facebook, :google_oauth2, :twitter, :linkedin]

  devise :omniauthable, :omniauth_providers => providers
  after_save :verify_and_reindex_timeline_items

  # paperclip
  has_attached_file :avatar, :styles => {
      :dashboard_header => "32x32#",
      :s65x65 => "65x65#",
      :s34x34 => "34x34#",
      :s336x336 => "336x336#",
      :s50x50 => "50x50#"
    }, :default_url => "/:style/missing.png"
  attr_accessor :delete_avatar
  before_validation { avatar.clear if delete_avatar == '1' }

  before_create :set_first_user_admin

  attr_accessor :terms_agree

  attr_accessor :voucher_id

  act_as_searchable

  # associations
  has_many :identities, dependent: :destroy
  has_many :subscriptions, inverse_of: :user, dependent: :destroy
  has_many :invoices, through: :subscriptions
  belongs_to :plan
  has_many :addresses, dependent: :destroy, inverse_of: :user
  has_many :credit_cards, dependent: :destroy, inverse_of: :user
  has_many :question_answers, inverse_of: :user, dependent: :destroy
  has_many :indications, class_name: 'User', inverse_of: :indicator, :foreign_key => "indicator_id", dependent: :destroy
  belongs_to :indicator, class_name: 'User', inverse_of: :indications
  has_many :user_steps, inverse_of: :user, dependent: :destroy
  has_many :steps, through: :user_steps
  has_many :chapters, through: :steps
  has_many :courses, through: :chapters
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :badge_users, dependent: :destroy
  has_many :badges, through: :badge_users
  has_many :points, inverse_of: :user, dependent: :destroy
  has_many :votes, inverse_of: :user, dependent: :destroy
  # has_many :comments, as: :resource, :class_name => 'ActiveAdmin::Comment', dependent: :destroy
  has_many :campaign_users, dependent: :destroy
  has_many :campaigns, through: :campaign_users, after_add: :update_campaign
  has_many :employee_advocacy_shares, inverse_of: :user, dependent: :destroy
  has_many :employee_advocacy_visits, through: :employee_advocacy_shares
  has_many :challenge_users, inverse_of: :user, dependent: :destroy
  has_many :hashtag_challenge_users, inverse_of: :user, dependent: :destroy
  has_many :visualizations
  has_many :broadcasts, through: :visualizations
  has_many :comments, inverse_of: :user, dependent: :destroy

  has_many :memberships
  has_many :domains, through: :memberships

  has_many :complete_account_question_option_users, inverse_of: :user, dependent: :destroy
  has_many :complete_account_question_options, through: :complete_account_question_option_users
  has_many :community_invites
  has_many :posts
  has_many :post_views
  has_many :viewed_posts, through: :post_views, source: :post

  has_many :notifications, foreign_key: :recipient_id
  has_many :devices, inverse_of: :user
  has_many :block_users, inverse_of: :blocker, foreign_key: :blocker_id

  after_destroy { |record| record.conversations.destroy_all }


  def add_coins(coins)
    self.available_coins = available_coins + coins
    save!
  end

  def remove_coins(coins)
    self.available_coins = available_coins - coins
    save!
  end

  def has_coins_quantity?(coins)
    available_coins >= coins
  end

  def conversations
    Conversation.where("sender_id = ? OR recipient_id = ?", id, id)
  end

  # OPTIMIZE: Check performance issues like N+1 problem
  def unread_messages
    current_domain = Domain.find_by(subdomain: Apartment::Tenant.current)
    conversations.includes(:messages).flat_map do |conversation|
      conversation.messages
                  .not_sent_by(self)
                  .unread
                  .order(created_at: :desc)
    end.select do |message|
      message.user.in_domain?(current_domain) ||
      message.user.admin_current_domain
    end
  end

  def count_unread_messages_sent_by(user)
    conversation = Conversation.between(self, user).first
    return 0 unless conversation

    conversation.messages
                .not_sent_by(self)
                .unread
                .size
  end

  acts_as_taggable

  acts_as_taggable_on :interest_categories, :interest_topics

  # serializations
  serialize :facebook_json, JSON

  # validations
  # validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update, if: :not_master?

  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  # validates_uniqueness_of :username, on: :update
  validates_presence_of :name
  # validates_presence_of :birthdate, :phone, if: [ :has_submited_payment_form ]
  # include ActiveModel::Validations
  validates_with VoucherFrancheeseValidator

  accepts_nested_attributes_for :addresses
  accepts_nested_attributes_for :credit_cards

  scope :top_engaged, -> { order('sum_points desc').limit(5) }
  scope :least_engaged, -> { order('sum_points asc').limit(5) }
  scope :domain, -> (domain) {
    domain.users_participating(self)
    # ids = joins(:domains).where('domains.id = ?', domain.id).pluck('id')
    # admin_ids = User.where(admin: true).pluck('id')

    # where(id: (ids + admin_ids).uniq)
  }
  scope :admin, -> { where(admin: true) }
  scope :not_admin, -> { where.not(admin: true) }
  scope :exclude, -> (user) { where.not(id: user) }

  scope :read_to_crawl, -> (social_network) {
    provider = social_network.to_sym == :youtube ? :google_oauth2 : social_network
    joins(:identities)
    .where({
      identities: {
        provider: provider
      }
    })
    .where(
      "next_#{social_network}_collect is null or next_#{social_network}_collect < ?",
      Time.now
    ).uniq
  }


  scope :read_to_crawl_advocacy, -> (social_network) {
    provider = social_network.to_sym == :youtube ? :google_oauth2 : social_network
    joins(:identities)
    .where({
      identities: {
        provider: provider
      }
    })
    .where(
      "next_#{social_network}_advocacy_collect is null or next_#{social_network}_advocacy_collect < ?",
      Time.now
    ).uniq
  }

  mount_uploader :facebook_page_picture_to_monitor, AvatarUploader
  mount_uploader :youtube_channel_picture_to_monitor, AvatarUploader

  def proccess_facebook_page_info_to_monitor domain
    domain = domain.master_domain_or_self_for_provider :facebook
    if facebook_page_id_to_monitor.present?
      access_token = self.identities.facebook.where(
        domain: domain).pluck('access_token').first

      if access_token.present?
        data = GraphFacebook.new(access_token).get_page_info(
          facebook_page_id_to_monitor)

        self.remote_facebook_page_picture_to_monitor_url = data['picture']['data']['url']
        self.facebook_page_name_to_monitor = data['name']
        self.save
      end
    end
  end

  def proccess_youtube_channel_info_to_monitor domain
    if youtube_channel_id_to_monitor.present?
      channel_info = YoutubeApiHelper.new(self, domain).get_channel_info youtube_channel_id_to_monitor
      if channel_info.snippet.present? and channel_info.snippet.thumbnails.present? and
        channel_info.snippet.thumbnails.high.present?
        picture_url = channel_info.snippet.thumbnails.high.url
        self.remote_youtube_channel_picture_to_monitor_url = picture_url
      end
      self.youtube_channel_name_to_monitor = channel_info.snippet.title
      self.save
    end
  end

  def update_campaign(campaign)
    campaign.save
  end

  def receive_reward?(campaign)
    campaign.campaign_users.where(user_id: self.id).any?
  end

  def email_required?
    self.has_submited_payment_form or self.created_in_dash
  end

  def get_points_for entity
    if entity.respond_to? :steps
      points = self.steps.where(id: entity.steps.pluck('id')).points
    else
      points = 0
    end

    if entity.is_a? Course
      badge = entity.current_finished_course_badge
      if badge.present? and self.has_badge? badge
        points += badge.badge_points
      end
    end

    points
  end

  def self.find_for_oauth(auth, signed_in_resource=nil, session={}, params)
    current_domain = DomainService.find session['current_domain_id']
    login_domain = current_domain.master_domain_or_self_for_provider auth.provider

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth, login_domain, current_domain, signed_in_resource)

    if identity.present? and identity.persisted?
      identity.token_invalid = false
      identity.save
    end

    if identity.nil? and current_domain.only_invited?
      raise OnlyInvitedException.new
    end

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.

    if identity.user.present? and signed_in_resource.present?
      if identity.user.id != signed_in_resource.id
        if session[:take_over] != 'true'
          return {
            identity: identity,
            error_type: 'has_other_user_associated'
          }
        end
      end
    end

    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email.present? && (auth.info.verified || auth.info.verified_email)
      email = "change@me-#{(1..10000).to_a.sample}.com"
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          #username: auth.info.nickname || auth.uid,
          email: email,
          password: Devise.friendly_token[0,20],
          indicator_id: session[:indicator_id],
          must_alter_password: true
        )

        user.skip_confirmation! if user.respond_to?(:skip_confirmation)

        if user.plan.nil? and Plan.count > 0 and not user.voucher.present?
          user.plan = Plan.first
        end
        session['user_has_been_created'] = 'true'
      end
    end

    if not user.name
      user.name = auth.info.name || auth.extra.raw_info.name
    end

    if not user.birthdate and auth.extra.raw_info.birthday.present?
      user.birthdate = Date.strptime(auth.extra.raw_info.birthday, "%m/%d/%Y")
    end

    if auth.info.image.present?
      avatar_url = user.process_uri(auth.info.image)
      user.update_attribute(:avatar, URI.parse(avatar_url))
      identity.remote_avatar_url = auth.info.image.gsub('http://','https://')
    end

    if auth.info.picture_url.present?
      avatar_url = user.process_uri(auth.info.picture_url)
      user.update_attribute(:avatar, URI.parse(avatar_url))
      identity.remote_avatar_url = auth.info.picture_url.gsub('http://','https://')
    end

    # user.send "=#{auth.provider}_json", auth
    user.save!

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
    end

    identity.json = auth
    identity.access_token = auth.credentials.token
    identity.access_token_secret = auth.credentials.secret


    if auth.credentials.refresh_token.present?
      identity.refresh_token = auth.credentials.refresh_token
    end

    identity.save!

    if identity.provider.to_s == "facebook"
      identity.update_fb_pages!
    end

    social_network = auth.provider
    if social_network == :google_oauth2
      social_network = :youtube
    end

    if user.respond_to? "next_#{social_network}_collect="
      user.send "next_#{social_network}_collect=", nil
      user.save
    end

    user
  end

  def verify_and_reindex_timeline_items
    if self.avatar_file_name_changed? or self.name_changed?
      ReindexAllTimelineItemWorker.perform_async self.id
    end
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def self.new_with_session(params, session)
    super.tap do |user|

      plan = Plan.by_moip_code session['plano']

      if not plan
        plan = Plan.active.where(moip_code: ENV['MOIP_PLAN_CODE']).first
      end

      if not plan
        plan = Plan.active.first
      end

      if user.plan.nil? and plan
        user.plan = plan
      end

      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end

      if session["invite_id"].present?
        invite = Invite.find session["invite_id"]
        user.email = invite.email if not user.email.present?
      end

    end
  end

  def process_uri(uri)
    open(uri, :allow_redirections => :safe) do |r|
      r.base_uri.to_s
    end
  end

  def moip_attributes
    if Rails.env.production?
      code = "#{self.name.parameterize[0..60]}#{self.id}"
    else
      code = "#{self.created_at.to_s.parameterize[0..60]}#{self.id}"
    end

    attrs = ActiveSupport::HashWithIndifferentAccess.new(self.attributes)
    attrs.slice(:email, :cpf).merge({
      fullname: self.name,
      birthdate_day: self.birthdate.day,
      birthdate_month: self.birthdate.month,
      birthdate_year: self.birthdate.year,
      phone_area_code: self.phone.split(') ')[0].split('(')[1],
      phone_number: self.phone.split(') ')[1].gsub('-', ''),
      code: code,
      address: {
        zipcode: 58340000,
        street: 'Rua Mocinha Caldas',
        number: '203',
        district: 'Nova Brasília',
        city: 'Sapé',
        state: 'PB',
        country: 'BRA',
      }
    })
  end

  def initialized_course?(course)
    self.courses.where(id: course.id).any?
  end

  def initialized_chapter?(chapter)
    self.chapters.where(id: chapter.id).any?
  end

  def initialized_step?(step)
    self.steps.where(id: step.id).any?
  end

  def init_step(step)
    self.user_steps.where(step: step).first_or_create
  end

  def chapters_not_completeds
    Chapter.where(id: self.chapters.select(:id)).joins(:steps)
      .joins("LEFT OUTER JOIN user_steps ON steps.id = user_steps.step_id and user_steps.user_id = #{self.id}")
      .where("user_steps.id is null")
      .uniq()
  end

  def chapters_completeds
    self.chapters.where.not(id: self.chapters_not_completeds.select(:id)).uniq()
  end

  def steps_completeds
    self.steps
  end

  def completed_chapter?(chapter)
    self.chapters_completeds.where(id: chapter.id).any?
  end

  def chapters_completeds_from_course(course)
    self.chapters_completeds.where(course_id: course.id)
  end

  def steps_completeds_from_chapter(chapter)
    steps_completeds.where(chapter_id: chapter.id)
  end

  def get_percentage_for(item)
    steps_count = item.steps.count
    return 0 if steps_count == 0
    item.steps.joins(:user_steps).where({user_steps: {user: self}}, self.id).count / steps_count.to_f
  end

  def get_percentage_for_course(course)
    self.get_percentage_for(course)
  end

  def get_percentage_for_chapter(chapter)
    self.get_percentage_for(chapter)
  end

  def finished_course?(course)
    self.get_percentage_for_course(course) == 1
  end

  def finished_quiz?(quiz)
    total_questions = 0#quiz.step_questions.count

    quiz.step_questions.each do |step_question|
      question_answer = self.question_answers.where(step_question: step_question).first

      if(question_answer.present? and question_answer.step_question_option.correct?)
        total_questions += 1
      end
    end

    total_questions == quiz.step_questions.count
  end

  def generate_sum_points
    self.sum_points = self.points.to_i
    self.save
  end

  # Returns all users and their total points received.
  # In this function, the '99 .yearss.ago..Time.now' range is used by default, 
  # so it is guaranteed that all points will be considered.
  def self.total_points_received range=(99.years.ago..Time.now)
    self.joins(:points)
      .where(points: {created_at: range})
      .where('points.value > 0')
      .select('users.*, sum(points.id), sum(points.value) as sum_points')
      .group('users.id')
      .order('SUM(points.value) desc')
  end

  def self.ranking range_str, count=false
    if range_str == 'last_24_hours'
      range = (1.day.ago..Time.now)
    end

    if range_str == 'last_7_days'
      range = (7.days.ago..Time.now)
    end

    if range_str == 'last_month'
      range = (1.month.ago..Time.now)
    end

    if not count
      self.total_points_received(range)
    else
      self.all.joins(:points).where({
        points: {
          created_at: range
        }
      }).where('points.value > 0').uniq.count
    end
  end

  def _check_campaigns_for_badge badge
    badge.campaigns.not_redeemable.each do |campaign|
      if campaign.has_complete_campaign?(self) and not self.has_complete_campaign(campaign)
        self.campaigns << campaign
        self.save
      end
    end
  end

  def _create_or_get_badge_user badge
    created = !self.has_badge?(badge)

    if created
      badge_user = self.badge_users.create!(badge: badge)
    else
      if badge.badge_type == 'reusable'
        badge_user = self.badge_users.create!(badge_id: badge.id)
      end
    end

    _check_campaigns_for_badge badge if created or badge.badge_type == 'reusable'

    return badge_user, created
  end

  def get_badge_user_for badge
    self.badge_users.where(badge: badge).first
  end

  def get_badge_users badge
    self.badge_users.where(badge: badge)
  end

  def _add_points options
    self.points.create options.merge(emit: true)
  end

  def _has_points? options
    self.points.where(options).any?
  end

  def add_badge(badge)
    if not badge.nil?
      badge_user, created = _create_or_get_badge_user badge

      if badge.badge_type == 'simple' and created
        if badge.badge_points > 0
          _add_points pointable: badge, value: badge.badge_points
        end

        return badge
      end

      if badge.badge_type == 'reusable'
        if badge.badge_points > 0
          _add_points pointable: badge, value: badge.badge_points
        end

        if not created
          badge_user.quantity += 1
          badge_user.save
        end

        return badge
      end
    end

    return nil
  end

  def remove_badge(badge)
    if not badge.nil? and self.has_badge?(badge)

      if self.badge_users.where(badge: badge).any?
        badge_user = self.badge_users.where(badge: badge).first

        if badge_user.quantity == 1
          badge.campaigns.not_redeemable.each do |campaign|
            campaings_for_self_and_badge = self.campaign_users.where(campaign: campaign)
            campaings_for_self_and_badge.destroy_all
          end

          badge_user.destroy
        else

          badge_user.quantity -= 1
          badge_user.save
        end

        if self.points.where(pointable: badge).any?
          self.points.where(pointable: badge).first.destroy
        end
      end

    end
  end

  def has_complete_campaign campaign
    self.campaigns.where(id: campaign.id).present?
  end

  def has_badge? badge
    self.badges.where(id: badge.id).present?
  end

  def badge_achievment_date(badge)
    self.badge_users.where(badge: badge).first.created_at
  end

  # check if an user has paid
  def active_to_use_app?
    self.subscriptions.active_to_user_app.any?
  end

  # check if an user has subscription active and pass trial
  # that is, paid
  def paid_authorized?
    self.subscriptions.real_active.any?
  end

  def get_social_account social, domain
    d = domain.master_domain_or_self_for_provider(social)
    self.identities.where(provider: social, domain: d).first
  end

  def get_franchisee
    if self.voucher.present?
      franchisee = Franchisee.all.tagged_with(self.tags, any: true).where(token: voucher).first
      return franchisee if franchisee.present?
      raise ActiveRecord::RecordNotFound.new("Franchisee de token #{self.voucher} não encontrada com as tags #{self.tag_list}")
    end

    raise ActiveRecord::RecordNotFound.new("Usuário não tem voucher para achar a franquia")
  end

  def get_plan_name
    begin
      franchisee = self.get_franchisee
      franchisee.decorate.formatted_plan
    rescue ActiveRecord::RecordNotFound => e
      if self.plan.present?
        self.plan.decorate.formatted_name
      else
        "Não conseguimos localizar o seu plano."
      end
    end
  end

  def avatar_timeline
    avatar.url(:s50x50)
  end

  def challenge_approved? challenge
    challenge.challenge_users.where(user: self, status: "approved").any?
  end

  def challenge_participating? challenge
    challenge.challenge_users.visible.where(user: self).any?
  end

  def hashtag_challenge_approved? hashtag_challenge
    hashtag_challenge.hashtag_challenge_users.where(user: self, status: "approved").any?
  end

  def get_identity_access_token identity_type, domain
    if self.identities.send(identity_type).where(domain: domain).any?
      self.identities.send(identity_type).where(domain: domain).first.access_token
    else
      raise NoIdentityFound.new("No identity was found for user #{self.id} from #{identity_type} for domain #{domain.id}")
    end
  end

  def in_domain?(domain)
    domains.find_by(id: domain.id)
  end

  def admin_current_domain
    domain ||= Domain.find_by(subdomain: Apartment::Tenant.current)
    admin_domain?(domain) || self[:admin]
  end

  def admin_domain?(domain)
    return false unless domain
    memberships.manager.where(domain: domain).any?
  end

  def create_membership! domain
    if ENV['SUBDOMAIN_AS_COMMUNITIES'] == 'false'
      if not domain.only_invited or (domain.only_invited and Invite.where(email: self.email, status: [:pending, :created]).any?)
        self.memberships.where(domain: domain).first_or_create
      end
    end
  end

  def visible_domains
    if admin
      Domain.all
    else
      domains
    end
  end

  def send_reset_password_instructions_with_options options={}
    token = set_reset_password_token
    send_devise_notification(:reset_password_instructions, token, options)

    token
  end

  def self.send_reset_password_instructions_with_options(attributes={}, options={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    recoverable.send_reset_password_instructions_with_options(options) if recoverable.persisted?
    recoverable
  end

  def viewed_post?(post)
    viewed_posts.where(id: post).any?
  end

  def get_fb_access_token domain
    get_identity_access_token :facebook, domain
  end

  def get_instagram_access_token domain
    get_identity_access_token :instagram, domain
  end

  def update_pages_and_run_collect domain
    begin
      self.proccess_facebook_page_info_to_monitor domain
      self.save
    rescue Exception => e
      ap e.message
      ap e.backtrace
    end

    begin
      self.proccess_youtube_channel_info_to_monitor domain
      self.save
    rescue Exception => e
      ap e.message
      ap e.backtrace
    end

    self.next_instagram_collect = nil
    self.next_facebook_collect = nil
    self.next_youtube_collect = nil
    self.save

    [:facebook, :youtube, :instagram].each do |provider|
      if User.read_to_crawl(provider).where(id: self.id).any?
        ap "runing collect for #{provider}"
        CrawlerCallerWorker.perform_async Apartment::Tenant.current, self.id, provider
      end
    end
  end

  def self.search(term)
    if term
      where("UNACCENT(LOWER(users.name)) LIKE UNACCENT(LOWER(?))", "%#{term}%")
    else
      all
    end
  end

  def last_badges
    badges.order(created_at: :desc).limit(4).uniq
  end

  def last_publications
    hashtag_challenge_users.social.order(created_at: :desc).limit(4)
  end

  def send_access_token_expired_mail
    domain = Domain.find_by subdomain: Apartment::Tenant.current
    AccessTokenMailer.expired(self, domain).deliver
    self.has_sent_access_token_expired_mail = true
    self.save
  end

  def generate_token_login!
    if not self.token_login.present?
      begin
        token = SecureRandom.hex
        raise UserHasGetToken.new if User.where(token_login: token).any?
        self.token_login = token
        self.save
      rescue UserHasGetToken => e
        retry
      end
    end
  end

  def get_facebook_pages_hash
    identities.facebook.map do |i|
      i.fb_pages
    end.select(&:present?).inject({}) do |memo, item|
      item.each do |page_id, hash|
        memo[page_id] = hash
      end
      memo
    end
  end

  def get_facebook_pages
    get_facebook_pages_hash.map do |k, v|
      v
    end
  end

  def get_facebook_pages_withou_access_token
    get_facebook_pages.map do |p|
      p.except "access_token"
    end
  end

  private

  def set_first_user_admin
    self.admin = true unless User.count > 0
  end
end
