# == Schema Information
#
# Table name: community_invites
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  domain_id  :integer
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class CommunityInvite < ActiveRecord::Base
  belongs_to :user
  belongs_to :domain

  STATUSES = %w(approved waiting_approval declined)

  scope :waiting_approval, -> { where(status: :waiting_approval) }
  scope :approved, -> { where(status: :approved) }

  def is_waiting_approval?
    status == 'waiting_approval'
  end

  def is_approved?
    status == 'approved'
  end

  def status
    self[:status] || 'waiting_approval'
  end

  def approve_with_role(role)
    return false unless is_waiting_approval?
    
    self.status = :approved
    membership = Membership.create(
      user: user,
      domain: domain,
      role: role
    )
    self.save
  end
end
