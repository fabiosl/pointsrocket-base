class Devise::CustomMailer < Devise::Mailer
  def mailer_sender(mapping, sender = :from)
    @domain.from_mail.present? ? @domain.from_mail : ENV['DEFAULT_MAIL_FROM']
  end

  # se ha uma forma melhor de passar opções e carrega-las eu desconheço
  def confirmation_instructions(record, token, opts={})
    @domain = opts.delete :domain
    super
  end

  def reset_password_instructions(record, token, opts={})
    @domain = opts.delete :domain
    super
  end

  def unlock_instructions(record, token, opts={})
    @domain = opts.delete :domain
    super
  end
end
