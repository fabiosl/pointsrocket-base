# Preview all emails at http://localhost:3000/rails/mailers/coin_user_mailer
class CoinUserMailerPreview < ActionMailer::Preview

  def new_coin_user_email
    coin_user = CoinUser.last
    CoinUserMailer.new_coin_user_email(coin_user)
  end
end
