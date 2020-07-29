# == Schema Information
#
# Table name: vouchers
#
#  id          :integer          not null, primary key
#  code        :string(255)
#  plan_id     :integer
#  price       :integer
#  valid_until :datetime
#  active      :boolean
#  created_at  :datetime
#  updated_at  :datetime
#  used_at     :datetime
#

class Voucher < ActiveRecord::Base
  belongs_to :plan
  validates_presence_of :price, :valid_until, :plan

  scope :active_to_be_used, -> { where(active: true, used_at: nil).where("valid_until > ?", Time.now) }

  after_initialize do
    if self.new_record?
      # values will be available for new record forms.
      self.active ||= true
      self.price ||= 1990
      self.plan ||= Plan.first
      self.valid_until = 1.year.from_now
      code = nil
      loop do
        code = "OnRocket-#{SecureRandom.hex(5)}"
        break if not Voucher.where(code: code).any?
      end
      self.code ||= code
    end
  end

  def self.get_active_voucher_by_code code
    voucher = active_to_be_used.where(code: code).first
    raise ActiveRecord::RecordNotFound if not voucher
    voucher
  end

  def get_price_in_cents
    self.price.to_i
  end
end
