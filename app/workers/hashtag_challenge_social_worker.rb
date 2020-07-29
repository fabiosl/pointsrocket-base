class HashtagChallengeSocialWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger

  sidekiq_options :queue => :default, :retry => true, backtrace: true

  def perform hashtag_challenge_id, apartment
    @apartment = apartment
    @domain = Domain.find_by subdomain: @apartment
    Apartment::Tenant.switch(apartment) do
      begin
        hashtag_challenge = HashtagChallenge.find hashtag_challenge_id
      rescue ActiveRecord::RecordNotFound => e
        ap "Tenant #{apartment} | #{e.message}"
        return
      end

      get_all_posts_for_hashtag_challenge(hashtag_challenge) do |posts_with_hashtags|
        posts_with_hashtags.each do |post_with_hashtag|
          users = get_users_for post_with_hashtag
          if users.any?
            users.each do |user|
              run_for user, hashtag_challenge, post_with_hashtag
            end
          end
        end
      end
    end
  end

  def get_all_posts_for_hashtag_challenge hashtag_challenge, &block
    from = 0
    size = 50

    while from > -1
      response = get_posts_for_hashtag_challenge hashtag_challenge, from, size

      if response["hits"]["hits"].present?
        yield response["hits"]["hits"]

        total = response["hits"]["total"]
        reached_now = from + size

        if reached_now < total
          from = reached_now
        else
          from = -1
        end
      else
        from = -1
      end
    end
  end

  def get_posts_for_hashtag_challenge hashtag_challenge, from, size

    must = [{
      match: {
        "message.hashtags" => hashtag_challenge.hashtag
      }
    }]

    if hashtag_challenge.date_start.present?
      must << {
        range: {
          created_time: {
            gte: hashtag_challenge.date_start.to_datetime.utc.strftime("%Y-%m-%d %H:%M:%S")
          }
        }
      }
    end

    if hashtag_challenge.date_end.present?
      must << {
        range: {
          created_time: {
            lte: hashtag_challenge.date_end.to_datetime.utc.strftime("%Y-%m-%d %H:%M:%S")
          }
        }
      }
    end

    body = {
      size: size,
      from: from,
      sort: {
        created_time: :desc,
      },
      query: {
        bool: {
          must: must
        }

      }
    }

    ap "#{ENV['ES_URL']}/#{ENV['ES_INDEX']}/post/_search"
    print body.to_json + "\n"

    response = HTTParty.post "#{ENV['ES_URL']}/#{ENV['ES_INDEX']}/post/_search",
      headers: {
        "Content-Type" => 'application/json'
      },
      body: body.to_json

    print response.body
    response
  end

  def get_users_for post_with_hashtag
    author_id = get_post_author_id post_with_hashtag
    social_network = get_post_social_network post_with_hashtag
    if social_network == "instagram"
      User.joins(:identities).where({
        identities: {
          provider: social_network,
          uid: author_id,
        }
      })
    elsif social_network == "facebook"
      User.where(facebook_page_id_to_monitor: author_id)
    elsif social_network == "youtube"
      User.where(youtube_channel_id_to_monitor: author_id)
    end
  end

  def get_post_id post_with_hashtag
    post_with_hashtag["_source"]["id"]
  end

  def get_post_author_id post_with_hashtag
    post_with_hashtag["_source"]["author"]["id"]
  end

  def get_post_social_network post_with_hashtag
    post_with_hashtag["_source"]["social_network"]
  end

  def get_post_url post_with_hashtag
    social_network = get_post_social_network post_with_hashtag
    if social_network == "youtube"
      "https://www.youtube.com/watch?v=#{get_post_id(post_with_hashtag)}"
    elsif social_network == "facebook"
      "https://facebook.com/#{get_post_id(post_with_hashtag)}"
    elsif post_with_hashtag["_source"]["link"].present?
      post_with_hashtag["_source"]["link"]
    else
      ""
    end
  end

  def get_post_description post_with_hashtag
    post_with_hashtag["_source"]["message"]
  end

  def run_for user, hashtag_challenge, post_with_hashtag
    if not user_has_hashtag_challenge_user? user, hashtag_challenge, get_post_id(post_with_hashtag)
      hashtag_challenge_user = create_hashtag_challenge_user_for! user, hashtag_challenge, post_with_hashtag
      TriggerEvent.new.run "new_hashtag_challenge_user", @domain, hashtag_challenge_user
      mail_notify hashtag_challenge_user
    else
      hashtag_challenge_user = get_hashtag_challenge_user_for user, hashtag_challenge, get_post_id(post_with_hashtag)
    end

    update_hashtag_challenge_user_social_attributes! hashtag_challenge_user, post_with_hashtag
  end

  def user_has_hashtag_challenge_user? user, hashtag_challenge, post_id
    user.hashtag_challenge_users.where(hashtag_challenge: hashtag_challenge, social_id: post_id).any?
  end

  def mail_notify hashtag_challenge_user
    HashtagChallengeUserMailer.new_publication_on_hashtag(@domain, hashtag_challenge_user).deliver if hashtag_challenge_user.user.subscribe
  end

  def create_hashtag_challenge_user_for! user, hashtag_challenge, post_with_hashtag
    user.hashtag_challenge_users.create!({
      hashtag_challenge: hashtag_challenge,
      social_id: get_post_id(post_with_hashtag),
      status: "approved",
      url: get_post_url(post_with_hashtag),
      json: post_with_hashtag.to_json
    })
  end

  def get_hashtag_challenge_user_for user, hashtag_challenge, post_id
    user.hashtag_challenge_users.where(hashtag_challenge: hashtag_challenge, social_id: post_id).first
  end

  def update_hashtag_challenge_user_social_attributes! hashtag_challenge_user, post_with_hashtag
    hashtag_challenge_user.json = post_with_hashtag.to_json
    hashtag_challenge_user.url = get_post_url(post_with_hashtag)
    hashtag_challenge_user.save!
  end

end
