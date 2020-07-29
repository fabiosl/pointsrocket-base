# == Schema Information
#
# Table name: how_to_point_items
#
#  id          :integer          not null, primary key
#  points      :integer
#  description :string(255)
#  section     :string(255)
#  domain_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe HowToPointItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
