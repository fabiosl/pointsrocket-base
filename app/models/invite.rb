# == Schema Information
#
# Table name: invites
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  status     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  token      :string(255)
#

class Invite < ActiveRecord::Base
  validates_presence_of :token, :email, :status
  validates_uniqueness_of :token

  def self.get_not_used_token
    token = rand(1000..9999).to_s
    while where(token: token).any?
      token = rand(1000..9999).to_s
    end
    token
  end

  def self.create_for email
    if not where(email: email).any?
      return self.create!(email: email, status: :pending, token: get_not_used_token)
    else
      return where(email: email, status: :pending).first
    end
  end

  def self.create_simple
    self.create!(
      email: "user-#{Time.now.to_i}@login.com",
      token: get_not_used_token,
      status: :pending
    )
  end
end
