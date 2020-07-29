class CreateOauth2Infos < ActiveRecord::Migration
  def change
    create_table :oauth2_infos do |t|
      t.string :provider, index: true
      t.string :uid
      t.string :access_token
      t.string :refresh_token

      t.timestamps
    end
  end
end
