# == Schema Information
#
# Table name: domain_br_badge_events
#
#  id         :integer          not null, primary key
#  domain_id  :integer
#  event      :string(255)
#  br_badge   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe DomainBrBadgeEvent, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
