# == Schema Information
#
# Table name: block_users
#
#  id         :integer          not null, primary key
#  blocker_id :integer
#  blocked_id :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe BlockUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
