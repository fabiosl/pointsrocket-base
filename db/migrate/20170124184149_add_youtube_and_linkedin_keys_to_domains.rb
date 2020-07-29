class AddYoutubeAndLinkedinKeysToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :youtube_app_id, :string
    add_column :domains, :youtube_app_secret, :string
    add_column :domains, :instagram_app_id, :string
    add_column :domains, :instagram_app_secret, :string
  end
end
