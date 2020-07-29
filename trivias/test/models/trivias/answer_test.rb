# == Schema Information
#
# Table name: trivias_answers
#
#  id           :integer          not null, primary key
#  question_id  :integer
#  play_id      :integer
#  correct      :boolean
#  seconds_took :integer
#  created_at   :datetime
#  updated_at   :datetime
#  option_id    :integer
#

require 'test_helper'

module Trivias
  class AnswerTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
