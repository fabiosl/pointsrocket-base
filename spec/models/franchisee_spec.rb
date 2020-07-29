# == Schema Information
#
# Table name: franchisees
#
#  id         :integer          not null, primary key
#  token      :string(255)
#  logo       :string(255)
#  name       :string(255)
#  domain_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Franchisee, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
