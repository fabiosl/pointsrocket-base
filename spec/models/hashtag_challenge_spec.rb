# == Schema Information
#
# Table name: hashtag_challenges
#
#  id                             :integer          not null, primary key
#  title                          :string(255)
#  date_start                     :datetime
#  date_end                       :datetime
#  points                         :integer
#  description                    :text
#  image                          :string(255)
#  slug                           :string(255)
#  badge_id                       :integer
#  hashtag                        :string(255)
#  terms                          :text
#  social_interactions_multiplier :float
#  created_at                     :datetime
#  updated_at                     :datetime
#

require 'rails_helper'

RSpec.describe HashtagChallenge, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
