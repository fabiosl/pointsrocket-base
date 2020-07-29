# == Schema Information
#
# Table name: visualizations
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  broadcast_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#  status       :string(255)
#

require 'rails_helper'

RSpec.describe Visualization, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
