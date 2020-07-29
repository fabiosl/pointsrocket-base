# == Schema Information
#
# Table name: coin_gives
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe CoinGive, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
