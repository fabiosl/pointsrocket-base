class CoinUserMailer < AppMailer

  def new_coin_user_email(coin_user)
    @domain = Domain.get_current_domain
    @coin_user = coin_user
    @coin_give = coin_user.coin_give
    @user = coin_user.recipient
    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']
    @url = "#{@domain.get_url}/dashboard?timelineable_id=#{@coin_give.id}&timelineable_type=CoinGive"

    with_user_locale do
      mail(
        to: @user.email,
        from: from_mail,
        subject: "#{I18n.t('models.coin_user.new')} - #{@domain.name}"
      )
    end
  end
end
