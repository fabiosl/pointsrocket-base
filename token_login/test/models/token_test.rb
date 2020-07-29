# == Schema Information
#
# Table name: tokens
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  key         :string(255)
#  valid_until :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class TokenTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
