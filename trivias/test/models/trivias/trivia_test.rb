# == Schema Information
#
# Table name: trivias_trivia
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  slug           :string(255)
#  published_date :datetime
#  created_at     :datetime
#  updated_at     :datetime
#

require 'test_helper'

module Trivias
  class TriviaTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
