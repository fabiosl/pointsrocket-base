# == Schema Information
#
# Table name: invites
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  token      :string(255)
#

require 'rails_helper'

RSpec.describe Invite, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
