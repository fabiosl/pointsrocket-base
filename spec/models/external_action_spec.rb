# == Schema Information
#
# Table name: external_actions
#
#  id         :integer          not null, primary key
#  text       :text
#  created_at :datetime
#  updated_at :datetime
#  domain_id  :integer
#

require 'rails_helper'

RSpec.describe ExternalAction, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
