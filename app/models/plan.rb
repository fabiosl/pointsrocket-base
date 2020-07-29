# == Schema Information
#
# Table name: plans
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  duration             :integer
#  price                :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  created_on_moip      :boolean          default(FALSE)
#  moip_code            :string(255)
#  amount               :integer
#  setup_fee            :integer
#  interval_unit        :string(255)
#  status               :string(255)
#  description          :string(255)
#  billing_cycles       :integer
#  trial_days           :integer
#  trial_hold_setup_fee :integer
#  active               :boolean          default(TRUE)
#

class Plan < ActiveRecord::Base
  # validates_precense_of :amount
  # alidates :amount, numericality: { only_integer: true }
  has_many :subscriptions, inverse_of: :plan, dependent: :destroy

  scope :active, -> { where(active: true) }
  scope :not_active, -> { where(active: false) }

  def self.by_moip_code moip_code
    return nil unless moip_code.present?
    Plan.active.where(moip_code: moip_code).first
  end

  def self.get_current_plan
    Plan.where(moip_code: ENV['MOIP_PLAN_CODE']).first || Plan.first
  end

end
