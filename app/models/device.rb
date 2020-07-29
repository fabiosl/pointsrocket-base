# == Schema Information
#
# Table name: devices
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  device_type              :string(255)
#  push_notification_token  :string(255)
#  device_id                :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  push_notification_active :boolean          default(TRUE)
#  name                     :string(255)
#

class Device < ActiveRecord::Base
  belongs_to :user, inverse_of: :devices

  validates_presence_of :name, :device_type, :device_id, :user_id
  validates_inclusion_of :device_type, :in => %w( ios android ), :message => "device_type must be -> ios or android"

  scope :ios, -> { where(device_type: :ios) }
  scope :android, -> { where(device_type: :android) }
  scope :push_notification_active, -> { where(push_notification_active: true) }
end
