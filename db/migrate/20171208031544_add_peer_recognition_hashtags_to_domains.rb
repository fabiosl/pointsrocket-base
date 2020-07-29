class AddPeerRecognitionHashtagsToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :peer_recognition_hashtags, :text
  end
end
