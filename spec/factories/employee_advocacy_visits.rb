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

FactoryGirl.define do
  factory :employee_advocacy_visit do
    employee_advocacy_share nil
    new_visit false
  end

end
