# == Schema Information
#
# Table name: trivias_user_answers
#
#  id             :integer          not null, primary key
#  user_trivia_id :integer
#  question_id    :integer
#  option_id      :integer
#  correct        :boolean
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

module Trivias
  class UserAnswerTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
