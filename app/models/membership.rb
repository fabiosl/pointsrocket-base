# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  domain_id  :integer
#  role       :integer          default(0)
#  created_at :datetime
#  updated_at :datetime
#

class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :domain

  ROLES = %i(user manager)

  enum role: ROLES

  validates_uniqueness_of :user_id, scope: :domain_id

  scope :manager, -> { where(role: Membership.roles[:manager]) }
end
