class AddHasSentAccessTokenExpiredMailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :has_sent_access_token_expired_mail, :boolean, default: false
  end
end
