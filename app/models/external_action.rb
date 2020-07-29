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

class ExternalAction < ActiveRecord::Base
  belongs_to :domain
end
