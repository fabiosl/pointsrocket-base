# == Schema Information
#
# Table name: user_steps
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  step_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe UserStep, type: :model do
end
