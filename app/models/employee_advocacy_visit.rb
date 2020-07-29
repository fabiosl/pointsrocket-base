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

class EmployeeAdvocacyVisit < ActiveRecord::Base
  belongs_to :employee_advocacy_share, inverse_of: :employee_advocacy_visits

  scope :new_visit, -> { where(new_visit: true) }
end
