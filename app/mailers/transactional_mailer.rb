class TransactionalMailer < ActionMailer::Base
  default from: 'hi@onrocket.com'
  layout 'mailer'

  def contactation_created(contact, to)
    @contact = contact
    @to = to

    mail(to: to[:email])
  end

  def invoice_alert(to, mail_params)
    @mail_params = mail_params
    mail(to: to)
  end


  def payment_alert(to, mail_params)
    @mail_params
    mail(to: to)
  end

  def subscription_alert(to, mail_params)
    @mail_params
    mail(to: to)
  end

  def reservation_created(reserva, to)
    @to = to
    @reserva = reserva
    mail(to: to)
  end

  def newsletter_created(newsletter, to)
    @to = to
    @newsletter = newsletter
    mail(to: to)
  end

  def welcome(to)
    mail(to: to)
  end
end
