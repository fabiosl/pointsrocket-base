class NewsletterMailer < AppMailer
  def new_newsletter_email(start_date, end_date, user, domain)
    @domain = domain
    @user = user
    @newsletter_data = newsletter_data(start_date, end_date)

    return if newsletter_empty?(@newsletter_data)

    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']

    with_user_locale do
      mail(
        to: @user.email,
        from: from_mail,
        subject: "#{I18n.t('mailers.newsletter.new')} - #{@domain.name}"
      )
    end
  end

  private

  def newsletter_data(start_date, end_date)
    {
      badges: Badge.where(created_at: start_date..end_date),
      courses: Course.where(created_at: start_date..end_date),
      employee_advocacy_posts: EmployeeAdvocacyPost.where(
        created_at: start_date..end_date
      ),
      hashtag_challenges: HashtagChallenge.where(
        created_at: start_date..end_date
      ).decorate,
      hashtag_challenge_users_top_engagement: HashtagChallengeUserDecorator
        .decorate_collection(
          HashtagChallengeUser.where(created_at: start_date..end_date)
                              .top_engagement_posts
        ),
      hashtag_challenge_users_count: HashtagChallengeUser.where(
        created_at: start_date..end_date
      ).size,
      most_pointed_users: CoinUser.where(created_at: start_date..end_date)
                                   .most_pointed_users,
      questions: Question.where(created_at: start_date..end_date).limit(2)
    }
  end

  def newsletter_empty?(newsletter_data)
    newsletter_data[:badges].size < 1 &&
    newsletter_data[:courses].size < 1 &&
    newsletter_data[:employee_advocacy_posts].size < 1 &&
    newsletter_data[:hashtag_challenges].size < 1 &&
    newsletter_data[:hashtag_challenge_users_count] < 1 &&
    newsletter_data[:hashtag_challenge_users_top_engagement].size < 1 &&
    newsletter_data[:most_pointed_users].size < 1 &&
    newsletter_data[:questions].size < 1
  end
end
