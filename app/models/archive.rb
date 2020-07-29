# == Schema Information
#
# Table name: archives
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  archive          :string(255)
#  archiveable_id   :integer
#  archiveable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Archive < ActiveRecord::Base
  mount_uploader :archive, UploaderUploader
  belongs_to :archiveable, polymorphic: true
end
