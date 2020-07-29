class AdminPushNotificationWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger
  include Rails.application.routes.url_helpers

  sidekiq_options queue: :default, retry: true, backtrace: true

  def perform(tenant, notifiable_type, notifiable_id, device_id)
    notifiable_class = "#{notifiable_type}".constantize

    Apartment::Tenant.switch(tenant) do
      @domain = Domain.find_by(subdomain: tenant)
      @notifiable = notifiable_class.find(notifiable_id)

      if not @notifiable.present?
        ap "Skiping: Notification hasn`t notifiable #{@notifiable.to_json}"
        return
      end

      with_user_locale do
        @device = Device.find(device_id)
        @user = @device.user
        @unread_notifications_count = @user.notifications.unread.count

        run_notification
      end
    end
  end

  def run_notification
    # override
  end

  def with_user_locale &block
    the_locale = I18n.locale

    if @user.present? and @user.locale.present?
      the_locale = @user.locale
    end

    I18n.with_locale(the_locale) do
      yield
    end
  end

  def notification_title
    notifiable_type = @notifiable.class.name
    if I18n.exists? "notification.push_notification.admin.#{notifiable_type}"
      I18n.t "notification.push_notification.admin.#{notifiable_type}", options_for_translation
    else
      I18n.t "notification.push_notification.admin.default"
    end
  end

  def user_name_or_empty user
    user.present? ? user.name.split(' ').first : ""
  end

  def short_url url
    UrlShortener.new(url).short
  end

  def get_url_checking_cache
    final_url = ""

    Sidekiq.redis do |redis|
      url = get_url
      redis_url = redis.get(url)
      if redis_url.present?
        final_url = redis_url
      else
        shortened_url = short_url(url)
        redis.set(url, shortened_url)
        redis.expire(url, 30.days.to_i)
        final_url = shortened_url
      end
    end

    final_url
  end

  def get_url
    @user.generate_token_login!
    base = @domain.get_url + "/api/tokens/token_login?token=#{@user.token_login}"
    ref = nil

    case @notifiable.class.name
    when "Answer"
      ref = questions_path(@notifiable.question.id)
    when "Broadcast"
      ref = broadcast_path(@notifiable)
    when "Campaign"
      ref = campaign_path(@notifiable)
    when "CampaignUser"
      campaign = @notifiable.campaign
      ref = campaign.redeem_points? ? campaigns_path : campaign_path(campaign)
    when "Challenge"
      ref = challenge_path(@notifiable)
    when "ChallengeUser"
      ref = challenge_path(@notifiable.challenge)
    when "HashtagChallenge"
      ref = hashtag_challenge_path(@notifiable)
    when "HashtagChallengeUser"
      ref = hashtag_challenge_path(@notifiable.hashtag_challenge)
    when "Comment"
      ref = @notifiable.decorate.path
    when "EmployeeAdvocacyPost"
      ref = employee_advocacy_path
    when "Post", "CoinGive"
      ref = "#{timeline_path}?timelineable_type=#{@notifiable.class.name}&" \
            "timelineable_id=#{@notifiable.id}"
    when "HashtagChallenge_create"
      ref = hashtag_challenge_path(@notifiable)
    when "HashtagChallengeUser_create"
      ref = hashtag_challenge_path(@notifiable.hashtag_challenge)
    when "Message"
      ref = "#{conversations_path(recipient_id: @notifiable.user_id)}"
    end

    if ref
      escaped_ref = CGI.escape "#{@domain.get_url}#{ref}"
      "#{base}&ref=#{escaped_ref}"
    else
      base
    end
  end

  def options_for_translation
    case @notifiable.class.name
    when "Answer"
      {
        user_name: user_name_or_empty(@notifiable.user),
        question_name: @notifiable.question.title
      }
    when "BadgeUser"
      { name: @notifiable.badge.name }
    when "Broadcast"
      { name: @notifiable.title }
    when "Campaign"
      { name: @notifiable.title }
    when "CampaignUser"
      {
        campaign_name: @notifiable.campaign.title,
        user_name: user_name_or_empty(@notifiable.user)
      }
    when "Challenge"
      { name: @notifiable.title }
    when "ChallengeUser"
      {
        challenge_name: @notifiable.challenge.title,
        user_name: user_name_or_empty(@notifiable.user)
      }
    when "Comment"
      { user_name: user_name_or_empty(@notifiable.user) }
    when "HashtagChallenge"
      { hashtag_challenge_name: @notifiable.title }
    when "HashtagChallengeUser"
      {
        hashtag_challenge_name: @notifiable.hashtag_challenge.title,
        user_name: user_name_or_empty(@notifiable.user)
      }
    when "Post"
      { user_name: user_name_or_empty(@notifiable.user) }
    when "Message"
      {
        sender_name: user_name_or_empty(@notifiable.user),
        content: @notifiable.body
      }
    when "EmployeeAdvocacyPost"
      {
        content: (@notifiable.title || @notifiable.content)
      }
    when "CoinGive"
      {
        content: "#{@notifiable.user.name}: #{ActionView::Base.full_sanitizer.sanitize(@notifiable.content)}"
      }
    else
      {}
    end
  end
end
