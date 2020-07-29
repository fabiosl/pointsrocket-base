# == Schema Information
#
# Table name: public.domains
#
#  id                                              :integer          not null, primary key
#  url                                             :string(255)
#  created_at                                      :datetime
#  updated_at                                      :datetime
#  name                                            :string(255)
#  has_indication                                  :boolean          default(FALSE)
#  is_points                                       :boolean          default(FALSE)
#  has_homepage                                    :boolean          default(FALSE)
#  default                                         :boolean          default(FALSE)
#  dashboard_image_down_file_name                  :string(255)
#  dashboard_image_down_content_type               :string(255)
#  dashboard_image_down_file_size                  :integer
#  dashboard_image_down_updated_at                 :datetime
#  dashboard_menu_image_file_name                  :string(255)
#  dashboard_menu_image_content_type               :string(255)
#  dashboard_menu_image_file_size                  :integer
#  dashboard_menu_image_updated_at                 :datetime
#  description                                     :text
#  layout                                          :string(255)
#  dashboard_login_image_file_name                 :string(255)
#  dashboard_login_image_content_type              :string(255)
#  dashboard_login_image_file_size                 :integer
#  dashboard_login_image_updated_at                :datetime
#  css                                             :string(255)
#  facebook_app_id                                 :string(255)
#  facebook_app_secret                             :string(255)
#  dashboard_menu_image_contract_file_name         :string(255)
#  dashboard_menu_image_contract_content_type      :string(255)
#  dashboard_menu_image_contract_file_size         :integer
#  dashboard_menu_image_contract_updated_at        :datetime
#  copyright                                       :string(255)
#  external_actions_rns                            :string(255)
#  employee_advocacy_enabled                       :boolean          default(FALSE)
#  after_signin_path                               :string(255)
#  twitter_app_id                                  :string(255)
#  twitter_app_secret                              :string(255)
#  linkedin_app_id                                 :string(255)
#  linkedin_app_secret                             :string(255)
#  dashboard_enabled                               :boolean          default(TRUE)
#  courses_enabled                                 :boolean          default(TRUE)
#  forum_enabled                                   :boolean          default(TRUE)
#  employee_advocacy_email_logo_image_file_name    :string(255)
#  employee_advocacy_email_logo_image_content_type :string(255)
#  employee_advocacy_email_logo_image_file_size    :integer
#  employee_advocacy_email_logo_image_updated_at   :datetime
#  youtube_app_id                                  :string(255)
#  youtube_app_secret                              :string(255)
#  instagram_app_id                                :string(255)
#  instagram_app_secret                            :string(255)
#  subdomain                                       :string(255)
#  css_text                                        :text
#  challenges_enabled                              :boolean          default(TRUE)
#  hashtag_challenges_enabled                      :boolean          default(TRUE)
#  broadcasts_enabled                              :boolean          default(TRUE)
#  campaigns_enabled                               :boolean          default(TRUE)
#  pass_domains_select_and_log_here_directly       :boolean          default(FALSE)
#  any_user_can_post                               :boolean          default(FALSE)
#  only_invited                                    :boolean          default(FALSE)
#  from_mail                                       :string(255)
#  challenge_localize_key                          :string(255)
#  login_terms_url                                 :string(255)
#  apn_key                                         :string(255)
#  social_network_permiteds                        :text
#  android_api_key                                 :string(255)
#  score_disabled                                  :boolean          default(FALSE)
#  login_providers                                 :string(255)
#  allow_content_report                            :boolean          default(FALSE)
#  weekly_user_coins                               :integer          default(0)
#  peer_recognition_enabled                        :boolean          default(FALSE)
#  peer_recognition_hashtags                       :text             default("")
#  advocacy_posts_limit_by_day                     :integer          default(0)
#  for_submission                                  :boolean          default(FALSE)
#  only_registered_hashtags                        :boolean          default(FALSE)
#  share_in_personal                               :boolean          default(TRUE)
#  share_in_fanpage                                :boolean          default(TRUE)
#

class Domain < ActiveRecord::Base

  has_many :how_to_point_items, inverse_of: :domain
  has_many :domain_br_badge_events, inverse_of: :domain
  has_many :franchisees, inverse_of: :domain

  has_many :memberships
  has_many :users, through: :memberships
  has_many :community_invites
  has_many :posts

  after_initialize do
    if self.new_record?
      self.layout = ENV['DEFAULT_DOMAIN_LAYOUT'] || 'general'
      self.is_points = true
    end
  end

  # paperclip
  has_attached_file :dashboard_image_down, :styles => {
      :thumb => "100x100#",
      :down => "220x",
    }, :default_url => "/:style/missing.png"
  attr_accessor :delete_dashboard_image_down
  before_validation { dashboard_image_down.clear if delete_dashboard_image_down == '1' }
  validates_attachment_content_type :dashboard_image_down, :content_type => /\Aimage\/.*\Z/

  has_attached_file :dashboard_menu_image, :styles => {
      :thumb => "100x100#",
      :logo => "110x",
    }, :default_url => "/original/community-logo.jpg"
  attr_accessor :delete_dashboard_menu_image
  before_validation { dashboard_menu_image.clear if delete_dashboard_menu_image == '1' }
  validates_attachment_content_type :dashboard_menu_image, :content_type => /\Aimage\/.*\Z/

  has_attached_file :dashboard_login_image, :styles => {
      :thumb => "100x100#",
      :logo => "110x",
    }, :default_url => "/:style/missing.png"
  attr_accessor :delete_dashboard_login_image
  before_validation { dashboard_login_image.clear if delete_dashboard_login_image == '1' }
  validates_attachment_content_type :dashboard_login_image, :content_type => /\Aimage\/.*\Z/

  has_attached_file :dashboard_menu_image_contract, :styles => {
      :thumb => "100x100#",
      :logo => "110x",
    }, :default_url => "/:style/missing.png"
  attr_accessor :delete_dashboard_menu_image_contract
  before_validation { dashboard_menu_image_contract.clear if delete_dashboard_menu_image_contract == '1' }
  validates_attachment_content_type :dashboard_menu_image_contract, :content_type => /\Aimage\/.*\Z/

  has_attached_file :employee_advocacy_email_logo_image, :styles => {
      :thumb => "100x100#",
      :logo => "110x",
    }, :default_url => "/:style/missing.png"
  attr_accessor :delete_employee_advocacy_email_logo_image
  before_validation { employee_advocacy_email_logo_image.clear if delete_employee_advocacy_email_logo_image == '1' }
  validates_attachment_content_type :employee_advocacy_email_logo_image, :content_type => /\Aimage\/.*\Z/

  mount_uploader :apn_key, FileUploader


  # validations
  validates_presence_of :url, :name
  validates_uniqueness_of :subdomain

  # tags
  acts_as_taggable

  accepts_nested_attributes_for :how_to_point_items, :allow_destroy => true
  accepts_nested_attributes_for :domain_br_badge_events, :allow_destroy => true

  after_create :create_tenant

  def influencer?
    hashtag_challenges_enabled
  end

  def get_url
    if url.present?
      url
    elsif subdomain.present? and ENV["MASTER_DOMAIN"].present?
      "http://" + subdomain + "." + ENV["MASTER_DOMAIN"]
    elsif ENV["MASTER_DOMAIN"].present?
      ENV["MASTER_DOMAIN"]
    else
      ""
    end
  end

  def master_domain_or_self_for_provider provider
    provider_to_option = provider.to_sym == :google_oauth2 ? :youtube : provider
    if self.send("#{provider_to_option}_app_id").present? and self.send("#{provider_to_option}_app_id") != 'null'
      return self
    end
    if @master_domain.nil? and ENV["MASTER_DOMAIN"].present?
      @master_domain = Domain.where(url: "http://#{ENV["MASTER_DOMAIN"]}").first
      if @master_domain.nil?
        @master_domain = Domain.where(url: "https://#{ENV["MASTER_DOMAIN"]}").first
      end
    end
    @master_domain
  end

  def master_domain
    master_domain = Domain.where(url: "http://#{ENV["MASTER_DOMAIN"]}").first
    if master_domain.nil?
      master_domain = Domain.where(url: "https://#{ENV["MASTER_DOMAIN"]}").first
    end
  end

  def get_android_api_key
    if self.android_api_key.present?
      self.android_api_key
    else
      self.master_domain.android_api_key
    end
  end

  def get_provider_client_id provider
    provider_to_option = provider.to_sym == :google_oauth2 ? :youtube : provider
    d = master_domain_or_self_for_provider(provider)

    app_id = nil

    if d
      app_id = d.send("#{provider_to_option}_app_id") || ENV["#{provider_to_option}_app_id".upcase]
    end

    return app_id if app_id != 'null'
  end

  def get_provider_client_secret provider
    provider_to_option = provider.to_sym == :google_oauth2 ? :youtube : provider
    d = master_domain_or_self_for_provider(provider)

    app_secret = nil

    if d
      app_secret = d.send("#{provider_to_option}_app_secret") || ENV["#{provider_to_option}_app_secret".upcase]
    end

    return app_secret if app_secret != 'null'
  end

  def permit_provider? provider
    provider_client_id_present = get_provider_client_id(provider).present?

    if social_network_permiteds.present? and social_network_permiteds != 'null'
      permited_in_attribute = social_network_permiteds.split(',').include? provider.to_s
      permited_in_attribute and provider_client_id_present
    else
      provider_client_id_present
    end
  end

  def users_participating(user_query=User.all)
    ids = user_query.joins(:domains).where('domains.id = ?', self.id).pluck('id')
    admin_ids = User.where(admin: true).pluck('id')

    User.where(id: (ids + admin_ids).uniq)
  end

  # Ensure any 'nil' field turn into empty string
  def as_json(opts={})
    json = super(opts)
    Hash[*json.map{|k, v| [k, v || ""]}.flatten]
  end

  def self.get_current_domain
    Domain.find_by subdomain: Apartment::Tenant.current
  end

  def self.c
    get_current_domain
  end

  private

  def create_tenant
    Apartment::Tenant.create(subdomain)
  end
end
