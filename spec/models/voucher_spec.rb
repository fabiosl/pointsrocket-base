# == Schema Information
#
# Table name: vouchers
#
#  id          :integer          not null, primary key
#  code        :string(255)
#  plan_id     :integer
#  price       :integer
#  valid_until :datetime
#  active      :boolean
#  created_at  :datetime
#  updated_at  :datetime
#  used_at     :datetime
#

require 'rails_helper'

RSpec.describe Voucher, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
