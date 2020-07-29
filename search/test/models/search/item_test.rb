# == Schema Information
#
# Table name: search_items
#
#  id              :integer          not null, primary key
#  searchable_id   :integer
#  searchable_type :string(255)
#  content         :text
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

module Search
  class ItemTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
