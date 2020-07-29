# == Schema Information
#
# Table name: challenge_users
#
#  id           :integer          not null, primary key
#  challenge_id :integer
#  user_id      :integer
#  status       :string(255)
#  feedback     :text
#  url          :string(255)
#  description  :text
#  created_at   :datetime
#  updated_at   :datetime
#  json         :text
#  social_id    :string(255)
#  file         :string(255)
#

require 'rails_helper'

RSpec.describe ChallengeUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
