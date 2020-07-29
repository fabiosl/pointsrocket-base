# == Schema Information
#
# Table name: challenges
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  date_start     :datetime
#  date_end       :datetime
#  points         :integer
#  description    :text
#  image          :string(255)
#  slug           :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  badge_id       :integer
#  terms          :text
#  privacy        :string(255)      default("all")
#  recommendation :text
#

require 'rails_helper'

RSpec.describe Challenge, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
