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

require 'rails_helper'

RSpec.describe Device, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
