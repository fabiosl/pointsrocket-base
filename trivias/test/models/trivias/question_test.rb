# == Schema Information
#
# Table name: trivias_questions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  slug       :string(255)
#  trivia_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

module Trivias
  class QuestionTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
