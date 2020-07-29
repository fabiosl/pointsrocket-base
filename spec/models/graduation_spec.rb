# == Schema Information
#
# Table name: graduations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  course_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Graduation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
