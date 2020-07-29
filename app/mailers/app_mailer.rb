class AppMailer < ActionMailer::Base
  default from: ENV['DEFAULT_MAIL_FROM']

  def with_user_locale &block
    the_locale = I18n.locale

    if @user.present? and @user.locale.present?
      the_locale = @user.locale
    end

    I18n.with_locale(the_locale) do
      yield
    end
  end
end
