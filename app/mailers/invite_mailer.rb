class InviteMailer < AppMailer

  def invite(invite, domain)
    @invite = invite
    @domain = domain
    from_mail = @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']

    with_user_locale do
      mail(
        to: @invite.email,
        from: from_mail,
        subject: "#{I18n.t('models.invites.new')} - #{@domain.name}"
      )
    end
  end
end
