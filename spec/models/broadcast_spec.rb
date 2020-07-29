# == Schema Information
#
# Table name: broadcasts
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  url           :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  schedule_time :datetime
#  description   :text
#  badge_id      :integer
#  points        :integer
#  slug          :string(255)
#

require 'rails_helper'

RSpec.describe Broadcast, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
