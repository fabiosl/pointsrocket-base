# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  domain_id  :integer
#  role       :integer          default(0)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Membership, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
