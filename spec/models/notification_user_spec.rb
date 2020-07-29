# == Schema Information
#
# Table name: notification_users
#
#  id              :integer          not null, primary key
#  notification_id :integer
#  user_id         :integer
#  is_read         :boolean          default(FALSE)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'rails_helper'

RSpec.describe NotificationUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
