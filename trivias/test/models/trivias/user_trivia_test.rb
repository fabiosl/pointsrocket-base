# == Schema Information
#
# Table name: trivias_user_trivia
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  trivia_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

module Trivias
  class UserTriviaTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
