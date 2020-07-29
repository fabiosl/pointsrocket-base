# User.all.select do |u| u.identities.twitter.present? and u.employee_advocacy_shares.twitter.any? end.reverse.each do |u| ap "runing for #{u.name}";
#   begin
#     AdvocacyCrawler.new.perform Apartment::Tenant.current, u.id, :twitter
#   rescue CrawlerCallerWorker::CollectException => e
#     ap e.message
#   end
# end

class AdvocacyCrawler < CrawlerCallerWorker

  class Collector

    def initialize user, domain
      @user = user
      @domain = domain
    end

    def get_publication_id publication
      publication["id"]
    end

    def get_credentials domain
      identity = @user.identities.where(domain: domain, provider: @provider).last

      if identity.access_token.present?
        {
          access_token: identity.access_token
        }
      else
        raise RuntimeError.new("No credentials found. (identity_id=#{identity.id}) (provider=#{identity.provider}) (user=#{@user.name}) (user_id=#{@user.id})")
      end
    end

    def publication_params publication
      {
        post_id: get_publication_id(publication)
      }
    end

    def run
      domain = @domain.master_domain_or_self_for_provider @provider

      if @user.identities.where(domain: domain, provider: @provider).any?
        credentials = get_credentials(domain)

        @user.employee_advocacy_shares.where(social_network: @provider).select do |eas|
          eas.social_json.present?
        end.each do |employee_advocacy_share|
          publications = JSON.parse(employee_advocacy_share.social_json)
          publications.each do |publication|
            if get_publication_id(publication).present?
              resp = HTTParty.post "#{AdvocacyCrawler::CRAWLER_URL}/api/#{@path}",
                headers: {
                  "Content-Type" => "application/json"
                },
                body: credentials.merge(publication_params(publication)).to_json

              if resp.success?
                if resp.parsed_response["status"] == "ok" and resp.parsed_response["response"].present?
                  publication["json"] = resp.parsed_response["response"]
                end
              else

                Rails.logger.info "CollectException #{@user.id} #{@user.email} #{@tenant} #{resp.parsed_response.to_json}"

                if resp.parsed_response['error_class'] == 'UserAlteredPasswordError'
                  Rails.logger.info "Puting collect to collect 5 days from now"
                  @user.identities.facebook.where(domain: domain).update_all(token_invalid: true)
                  @user.send_access_token_expired_mail if not @user.has_sent_access_token_expired_mail
                  @next_collect = 5.days.from_now
                  return
                end

                if resp.parsed_response.dig("error", 'data').is_a?(Array) &&
                  resp.parsed_response.dig("error", 'data').first.is_a?(Hash)

                  if resp.parsed_response.dig("error", 'data').first["code"] == 144
                    Rails.logger.info "#{publication} No status exists, probably erased. Skiping"
                    next
                  end

                  if resp.parsed_response.dig("error", 'data').first["code"] == 89
                    Rails.logger.info "#{publication} Invalid token"
                    @next_collect = 10.day.from_now
                    return
                  end
                end

                if resp.parsed_response.dig('error', "data", "code") == 100 &&
                  resp.parsed_response.dig('error', "data", "error_subcode") == 33

                  Rails.logger.info "Publication doesn`t exists, skiping"
                  next
                end

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

                # Error validating access token: Session has expired
                if resp.parsed_response.dig('error', "data", "code") == 190 &&
                  resp.parsed_response.dig('error', "data", "error_subcode") == 463

                  Rails.logger.info "Puting collect to collect 10 day from now, #{resp.parsed_response}"
                  @next_collect = 10.days.from_now
                  return
                end

                raise AdvocacyCrawler::CollectException.new(resp.parsed_response)
              end
            end
          end

          employee_advocacy_share.social_json = publications.to_json
          employee_advocacy_share.save
        end
      end
    end

  end

  class FacebookCollector < Collector
    def initialize *params
      super
      @provider = :facebook
      @path = "facebook/collect_post"
    end
  end

  class TwitterCollector < Collector
    def initialize *params
      super
      @provider = :twitter
      @path = "twitter/collect_tweet"
    end

    def publication_params publication
      {
        tweetId: get_publication_id(publication).to_s
      }
    end

    def get_credentials domain
      identity = @user.identities.where(domain: domain, provider: @provider).last

      if not domain.twitter_app_id.present? or not domain.twitter_app_secret.present?
        raise RuntimeError.new("No twitter_app_id or twitter_app_secret. (domain_id=#{domain.id}")
      end

      if not identity.access_token.present? or not identity.access_token_secret.present?
        raise RuntimeError.new("No access_token or access_token_secret. (identity=#{identity.id}")
      end

      {
        consumerKey: domain.twitter_app_id,
        consumerSecret: domain.twitter_app_secret,
        accessToken: identity.access_token,
        accessTokenSecret: identity.access_token_secret,
      }
    end

  end

  def update_next_collect user, social_network
    user.send "next_#{social_network}_advocacy_collect=", calculate_next_crawl(user, social_network)
  end

  def calculate_next_crawl user, social_network
    # não é pra coletar entre as 0 horas e 5 da manha, evitar estouro
    # ninguem vai entrar nessa hora
    if @next_collect.present?
      return @next_collect
    end

    1.day.from_now.beginning_of_day + rand(0..120).minutes
  end

  def facebook user, days
    FacebookCollector.new(user, @domain).run
  end

  def twitter user, days
    TwitterCollector.new(user, @domain).run
  end

end
