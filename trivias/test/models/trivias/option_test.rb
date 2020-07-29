# == Schema Information
#
# Table name: trivias_options
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  correct     :boolean
#  question_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

module Trivias
  class OptionTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
