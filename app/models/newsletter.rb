# == Schema Information
#
# Table name: newsletters
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Newsletter < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true, email: true, uniqueness: true
end
