class CrawlerCallerWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  class CollectException < Exception ; end

  CRAWLER_URL = ENV['CRAWLER_URL']

  sidekiq_options :queue => :default, retry: true, backtrace: true

  def perform tenant, user_id, social_network, days=nil
    if social_network.to_sym == :youtube and ENV['DISABLE_YOUTUBE_COLLECT'].present?
      ap "disabling youtube collect"
      return
    end

    ap "disabled for now"
    return

    @tenant = tenant.present? ? tenant : "public"
    if not Apartment.tenant_names.include? @tenant.to_s
      ap "No tenant for #{tenant}"
      return
    end
    @domain = Domain.find_by subdomain: @tenant
    Apartment::Tenant.switch(tenant) do
      days = days || 30
      @next_collect = nil

      begin
        user = User.find user_id
      rescue ActiveRecord::RecordNotFound => e
        return "User not found for #{user_id}"
      end

      begin
        self.send social_network, user, days
        update_next_collect user, social_network
        user.save
      rescue GoogleHelper::NoIdentityFound => e
        return
      end
    end
  end

  def update_next_collect user, social_network
    user.send "next_#{social_network}_collect=", calculate_next_crawl(user, social_network)
  end

  def calculate_next_crawl user, social_network
    # não é pra coletar entre as 0 horas e 5 da manha, evitar estouro
    # ninguem vai entrar nessa hora
    if @next_collect.present?
      return @next_collect
    end

    if user.last_access.present? and user.last_access > 30.minutes.ago
      5.minutes.from_now
    else
      if Time.now.hour >= 0 and Time.now.hour <= 5
        Time.now.beginning_of_day + 6.hours + rand(0..30).minutes
      else
        Time.now + rand(50..70).minutes
      end
    end
  end

  def facebook user, days
    domain = @domain.master_domain_or_self_for_provider :facebook

    if user.identities.where(domain: domain).facebook.any?
      access_token = user.identities.facebook.where(domain: domain).last.access_token
      page_id = user.facebook_page_id_to_monitor

      if access_token.present? and page_id.present?
        resp = HTTParty.post "#{CRAWLER_URL}/api/facebook/collect",
          headers: {
            "Content-Type" => "application/json"
          },
          body: {
            access_token: access_token,
            days: days,
            page_id: page_id,
            es_index: ENV['ES_INDEX'],
            es_url: ENV['ES_URL'],
          }.to_json
        if resp.code != 200
          Rails.logger.info "CollectException #{user.id} #{user.email} #{@tenant} #{resp.parsed_response.to_json}"
          if resp.parsed_response['error_class'] == 'UserAlteredPasswordError'
            Rails.logger.info "Puting collect to collect 5 days from now"
            user.identities.facebook.where(domain: domain, access_token: access_token).update_all(token_invalid: true)
            user.send_access_token_expired_mail if not user.has_sent_access_token_expired_mail
            @next_collect = 5.days.from_now
            return
          end

          if resp.parsed_response.dig('error', "data", "message") == "(#4) Application request limit reached"
            Rails.logger.info "Puting collect to collect 1 day from now, #{resp.parsed_response}"
            @next_collect = 1.day.from_now
            return
          end

          if resp.parsed_response['error_class'] == 'AppError' &&
            resp.parsed_response.dig('error', "data", "code") == 100 &&
            resp.parsed_response.dig('error', "data", "error_subcode") == 33

            Rails.logger.info "Puting collect to collect 1 day from now, #{resp.parsed_response}"
            @next_collect = 1.day.from_now
            return
          end

          if resp.parsed_response['error_class'] == "SwitchableAccessTokenError"
            # The user has not authorized application 1097852456973448
            if resp.parsed_response.dig('error', "data", "code") == 190 &&
              resp.parsed_response.dig('error', "data", "error_subcode") == 458

              Rails.logger.info "Puting collect to collect 10 day from now, #{resp.parsed_response}"
              @next_collect = 10.day.from_now
              return
            end

            # fb user not a confirmed user
            if resp.parsed_response.dig('error', "data", "code") == 190 &&
              resp.parsed_response.dig('error', "data", "error_subcode") == 464

              Rails.logger.info "Puting collect to collect 10 day from now, #{resp.parsed_response}"
              @next_collect = 10.days.from_now
              return
            end
          end

          raise CollectException.new(resp.parsed_response)
        end
      else
        ap "User has not fb access token or hasn`t choose page to monitor yet"
      end
    end
  end

  def instagram user, days
    domain = @domain.master_domain_or_self_for_provider :instagram

    if user.identities.where(domain: domain).instagram.any?
      access_token = user.identities.where(domain: domain).instagram.last.access_token

      if access_token.present?
        resp = HTTParty.post "#{CRAWLER_URL}/api/instagram/collect",
          headers: {
            "Content-Type" => "application/json",
          },
          body: {
            access_token: access_token,
            days: days,
            es_index: ENV['ES_INDEX'],
            es_url: ENV['ES_URL'],
          }.to_json

        if resp.code != 200
          ap "CollectException #{user.id} #{user.email} #{@tenant} #{resp.parsed_response.to_json}"

          if resp.parsed_response['error_class'] == 'AppError' and
            resp.parsed_response['error']['data']['error_type'] == 'OAuthAccessTokenException'
            Rails.logger.info "Puting collect to collect 5 days from now"
            user.identities.instagram.where(domain: domain, access_token: access_token).update_all(token_invalid: true)
            user.send_access_token_expired_mail if not user.has_sent_access_token_expired_mail
            @next_collect = 5.days.from_now
            return
          end
          raise CollectException.new(resp.parsed_response)
        end
      else
        ap "User has not instagram access token"
      end
    end
  end

  def youtube user, days
    d = @domain.master_domain_or_self_for_provider :google_oauth2

    auth = GoogleHelper.authorization_for_user user, d
    auth.redirect_uri = "http://naoaltere.me"

    if auth.access_token.present? && user.youtube_channel_id_to_monitor.present?
      auth_json = JSON.parse(auth.to_json)
      if auth.expires_at.present?
        must_refresh_token = auth.expires_at.to_datetime < Time.now.to_datetime
      else
        must_refresh_token = true
      end

      if must_refresh_token and not auth.refresh_token.present?
        ap "#{user.id} #{user.email} #{@tenant} Must refresh token and no refresh token is present, user must reauthenticate"
        return
      end

      resp = HTTParty.post "#{CRAWLER_URL}/api/youtube/collect",
        headers: {
          "Content-Type" => "application/json",
        },
        body: {
          channel_id: user.youtube_channel_id_to_monitor,
          access_token: auth.access_token,
          refresh_token: auth.refresh_token,
          must_refresh_token: must_refresh_token,
          app_id: auth.client_id,
          app_secret: auth.client_secret,
          days: days,
          es_index: ENV['ES_INDEX'],
          es_url: ENV['ES_URL'],
        }.to_json

      if resp.code != 200
        if resp.parsed_response["error"] == "invalid_grant"
          ap "#{user.id} #{user.email} #{@tenant} invalid grant, must be because user has revoked or something like that"
          return
        else
          ap "CollectException #{user.id} #{user.email} #{@tenant} #{resp.parsed_response.to_json}"
          raise CollectException.new(resp.parsed_response)
        end
      end
    end

  end
end
