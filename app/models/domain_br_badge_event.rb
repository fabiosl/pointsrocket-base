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

class DomainBrBadgeEvent < ActiveRecord::Base
  belongs_to :domain, inverse_of: :domain_br_badge_events

  validates_presence_of :domain, :br_badge, :event
end
