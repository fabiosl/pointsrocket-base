# == Schema Information
#
# Table name: identities
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  provider            :string(255)
#  uid                 :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  name                :string(255)
#  access_token        :text
#  access_token_secret :string(255)
#  json                :text
#  domain_id           :integer
#  avatar              :string(255)
#  refresh_token       :string(255)
#  token_invalid       :boolean          default(FALSE)
#  scopes              :text
#  fb_pages            :text
#

class Identity < ActiveRecord::Base
  belongs_to :user
  belongs_to :domain
  validates_presence_of :uid, :provider, :access_token
  validates_uniqueness_of :uid, :scope => [:provider, :domain]
  serialize :json, JSON
  serialize :fb_pages, JSON
  mount_uploader :avatar, AvatarUploader

  scope :facebook, -> { where(provider: :facebook) }
  scope :twitter, -> { where(provider: :twitter) }
  scope :linkedin, -> { where(provider: :linkedin) }
  scope :instagram, -> { where(provider: :instagram) }
  scope :google_oauth2, -> { where(provider: :google_oauth2) }
  scope :youtube, -> { google_oauth2 }

  after_save :index_oauth2_info
  after_create :index_oauth2_info

  def index_oauth2_info
    if refresh_token.present?
      oauth2info = Oauth2Info.where(provider: provider, uid: uid).first_or_create
      oauth2info.refresh_token = refresh_token
      oauth2info.access_token = access_token
      oauth2info.save!
    end
  end

  def get_refresh_token
    oauth2_info = Oauth2Info.where(provider: provider, uid: uid).first
    if oauth2_info.present?
      oauth2_info.refresh_token
    else
      nil
    end
  end

  def update_fb_pages!
    self.fb_pages = GraphFacebookPages
      .new(user, Domain.get_current_domain)
      .get_pages
      .inject({}) do |memo, item|
        memo[item["id"]] = item
        memo
      end
    self.save
  end

  def self.get_granted_scopes token
    begin
      response = HTTParty.get("https://graph.facebook.com/v2.10/me/permissions", {
        headers: {
          "Content-Type" => "application/json",
          "Accept" => "application/json"
        },
        query: {
          access_token: token
        }
      })

      if response.parsed_response["data"].present?

        perms = response.parsed_response["data"].select do |p|
          p["status"] == "granted"
        end.map do |p|
          p["permission"]
        end.join(',')

        return perms
      end
    rescue Exception => e
      return nil
    end
  end

  def self.find_for_oauth(auth, login_domain, current_domain, signed_in_user)
    email = auth.info.email
    email_is_verified = auth.info.verified || auth.info.verified_email
    can_log_with_email = false

    granted_scopes = nil

    if auth.provider.to_s == 'facebook'
      granted_scopes = get_granted_scopes(auth.credentials.token)
    end

    if email.present? and email_is_verified
      can_log_with_email = Invite.where(email: email, status: [:pending, :created]).any?
    end

    # se o dominio nao for de apenas convidado ou
    # se o email do usuário da rede social estiver na lista dos invites ou
    # se o usuário ja estiver logado (pq ja criou a conta)
    if not current_domain.only_invited? or can_log_with_email or not signed_in_user.nil?
      identity = find_or_create_by({
        uid: auth.uid, provider: auth.provider, domain: login_domain}) do |identity|

        identity.name = auth.info.name
        identity.access_token = auth.credentials.token
        identity.access_token_secret = auth.credentials.secret
        identity.token_invalid = false
        identity.scopes = granted_scopes
      end
    else
      identity = where({uid: auth.uid, provider: auth.provider, domain: login_domain}).first
    end

    if identity.present?
      identity.scopes = granted_scopes
      identity.save
    end
    identity
  end
end
