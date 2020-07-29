class AddPeerRecognitionEnabledToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :peer_recognition_enabled, :boolean, default: false
  end
end
