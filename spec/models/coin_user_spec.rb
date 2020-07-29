# == Schema Information
#
# Table name: coin_users
#
#  id           :integer          not null, primary key
#  sender_id    :integer
#  recipient_id :integer
#  points       :integer          default(0)
#  created_at   :datetime
#  updated_at   :datetime
#  content      :text
#  coin_give_id :integer
#  hashtags     :text             default([]), is an Array
#

require 'rails_helper'

RSpec.describe CoinUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
