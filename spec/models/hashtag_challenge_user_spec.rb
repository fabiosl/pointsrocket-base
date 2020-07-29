# == Schema Information
#
# Table name: hashtag_challenge_users
#
#  id                   :integer          not null, primary key
#  hashtag_challenge_id :integer
#  status               :string(255)
#  url                  :string(255)
#  json                 :text
#  social_id            :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  user_id              :integer
#  feedback             :text
#

require 'rails_helper'

RSpec.describe HashtagChallengeUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
