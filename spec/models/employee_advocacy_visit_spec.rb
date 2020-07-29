# == Schema Information
#
# Table name: employee_advocacy_visits
#
#  id                         :integer          not null, primary key
#  employee_advocacy_share_id :integer
#  new_visit                  :boolean
#  created_at                 :datetime
#  updated_at                 :datetime
#

require 'rails_helper'

RSpec.describe EmployeeAdvocacyVisit, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
