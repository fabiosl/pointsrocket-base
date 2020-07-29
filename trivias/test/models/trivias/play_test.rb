# == Schema Information
#
# Table name: trivias_plays
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  questions   :text
#  created_at  :datetime
#  updated_at  :datetime
#  stopped     :boolean
#  stop_reason :string(255)
#

require 'test_helper'

module Trivias
  class PlayTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
