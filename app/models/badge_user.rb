# == Schema Information
#
# Table name: badge_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  badge_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  quantity   :integer          default(1)
#

class BadgeUser < ActiveRecord::Base
  include Notifiable

  belongs_to :user
  belongs_to :badge

  after_create :mail_user

  act_as_timelineable type: :user

  private

  def mail_user
    domain = Domain.find_by(subdomain: Apartment::Tenant.current)
    BadgeUserMailWorker.perform_async(domain.id, user.id, id)
  end
end
