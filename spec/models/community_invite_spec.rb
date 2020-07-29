# == Schema Information
#
# Table name: community_invites
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  domain_id  :integer
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe CommunityInvite, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
