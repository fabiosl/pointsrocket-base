class PushNotificationWorker
  include Sidekiq::Worker
  include Sidekiq::Parameters::Logger
  include Rails.application.routes.url_helpers

  sidekiq_options queue: :default, retry: true, backtrace: true

  def perform(tenant, notification_id, device_id)
    Apartment::Tenant.switch(tenant) do
      @domain = Domain.find_by(subdomain: tenant)
      @notification = Notification.find(notification_id)

      if not @notification.notifiable.present?
        ap "Skiping: Notification hasn`t notifiable #{@notification.to_json}"
        return
      end

      with_user_locale do
        @user = @notification.recipient
        @unread_notifications_count = @user.notifications.unread.count
        @device = Device.find(device_id)

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
    notification_type = @notification.notification_type
    if I18n.exists? "notification.push_notification.#{notification_type}"
      I18n.t "notification.push_notification.#{notification_type}", options_for_translation
    else
      I18n.t "notification.push_notification.default"
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

    notifiable = @notification.notifiable
    case @notification.notification_type
    when "Answer_create", "Answer_mention_user"
      ref = question_path(notifiable.question.id)
    when "Broadcast_create"
      ref = broadcast_path(notifiable)
    when "Campaign_create"
      ref = campaign_path(notifiable)
    when "Challenge_create"
      ref = challenge_path(notifiable)
    when "ChallengeUser_create"
      ref = challenge_path(notifiable.challenge)
    when "ChallengeUser_approved"
      ref = challenge_path(notifiable.challenge)
    when "ChallengeUser_declined"
      ref = challenge_path(notifiable.challenge)
    when "EmployeeAdvocacyPost_create"
      ref = employee_advocacy_path
    when "Comment_create", "Comment_mention_user"
      ref = notifiable.decorate.path
    when "Post_create", "Post_mention_user"
      ref = "#{timeline_path}?timelineable_type=#{notifiable.class.name}&" \
            "timelineable_id=#{notifiable.id}"
    when "CoinUser_create"
      ref = "#{timeline_path}?timelineable_type=CoinGive&" \
            "timelineable_id=#{notifiable.coin_give.id}"
    when "HashtagChallenge_create"
      ref = hashtag_challenge_path(notifiable)
    when "HashtagChallengeUser_create"
      ref = hashtag_challenge_path(notifiable.hashtag_challenge)
    when "Message_create"
      ref = "#{conversations_path(recipient_id: notifiable.user_id)}"
    end

    if ref
      escaped_ref = CGI.escape "#{@domain.get_url}#{ref}"
      "#{base}&ref=#{escaped_ref}"
    else
      base
    end
  end

  def options_for_translation
    notifiable = @notification.notifiable
    case @notification.notification_type
    when "Answer_create"
      {
        user_name: user_name_or_empty(notifiable.user),
        question_name: notifiable.question.title,
      }
    # when "Badge_create"
    when "BadgeUser_create"
      {
        name: notifiable.badge.name,
      }
    when "Broadcast_create"
      {
        name: notifiable.title
      }
    when "Campaign_create"
      {
        name: notifiable.title
      }
    when "Challenge_create"
      {
        name: notifiable.title
      }
    when "ChallengeUser_create"
      {
        challenge_name: notifiable.challenge.title
      }
    when "ChallengeUser_approved"
      {
        challenge_name: notifiable.challenge.title
      }
    when "ChallengeUser_declined"
      {
        challenge_name: notifiable.challenge.title
      }
    when "CoinUser_create"
      {
        name: notifiable.sender.name,
        points: notifiable.points
      }
    when "Comment_create"
      {
        user_name: user_name_or_empty(notifiable.user)
      }
    when "Comment_mention_user"
      {
        user_name: user_name_or_empty(notifiable.user)
      }
    when "Answer_mention_user"
      {
        user_name: user_name_or_empty(notifiable.user)
      }
    when "HashtagChallenge_create"
      {
        hashtag_challenge_name: notifiable.title,
      }
    when "HashtagChallengeUser_create"
      {
        hashtag_challenge_name: notifiable.hashtag_challenge.title,
        user_name: user_name_or_empty(notifiable.user)
      }
    when "Post_create"
      {
        user_name: user_name_or_empty(notifiable.user)
      }
    when "Post_mention_user"
      {
        user_name: user_name_or_empty(notifiable.user)
      }
    when "Message_create"
      {
        sender_name: user_name_or_empty(notifiable.user),
        content: notifiable.body
      }
    when "EmployeeAdvocacyPost_create"
      {
        content: (notifiable.title || notifiable.content)
      }
    when "Domain_reset_weekly_user_coins"
      {
        points: notifiable.weekly_user_coins
      }
    else
      {}
    end
  end
end
