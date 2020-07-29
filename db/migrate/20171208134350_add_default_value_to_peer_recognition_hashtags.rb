class AddDefaultValueToPeerRecognitionHashtags < ActiveRecord::Migration
  def change
    change_column :domains, :peer_recognition_hashtags, :text, default: ''
  end
end
