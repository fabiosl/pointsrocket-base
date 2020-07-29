# == Schema Information
#
# Table name: points
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  pointable_id   :integer
#  pointable_type :string(255)
#  value          :integer          default(0)
#  created_at     :datetime
#  updated_at     :datetime
#

class Point < ActiveRecord::Base

  # associations
  belongs_to :user, inverse_of: :points
  belongs_to :pointable, polymorphic: true

  # callbacks
  after_destroy :generate_user_sum_points
  after_update :generate_user_sum_points
  after_create :generate_user_sum_points

  after_create :trigger_event_it
  after_update :trigger_event_it

  acts_as_taggable
  act_as_emitable

  def trigger_event_it
    domain = Domain.find_by subdomain: Apartment::Tenant.current
    if domain.present?
      TriggerEvent.new.run "new_or_update_point", domain, self
    end
  end

  def self.to_i
    self.sum('value')
  end

  def self.last_24_hours
    self.by_date_range(1.day.ago..Time.now)
  end

  def self.last_7_days
    self.by_date_range(7.days.ago..Time.now)
  end

  def self.last_month
    self.by_date_range(1.month.ago..Time.now)
  end

  def self.by_date_range range
    self.where(created_at: range)
  end

  def generate_user_sum_points
    if self.user
      self.user.generate_sum_points
    end
  end

end
