# == Schema Information
#
# Table name: subscriptions
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  moip_code            :integer
#  status               :string(255)
#  remote_creation_date :datetime
#  amount               :integer
#  plan_id              :integer
#  next_invoice_date    :datetime
#  trial_start_time     :datetime
#  trial_end_time       :datetime
#  created_at           :datetime
#  updated_at           :datetime
#  not_renew            :boolean          default(FALSE)
#  active_until         :datetime
#  first_paid_day       :datetime
#  suspend_in           :datetime
#  suspended_in         :datetime
#  voucher_id           :integer
#

class Subscription < ActiveRecord::Base
  belongs_to :user, inverse_of: :subscriptions
  has_many :invoices, inverse_of: :subscription, dependent: :destroy
  belongs_to :plan, inverse_of: :subscriptions
  belongs_to :voucher
  scope :active, -> { where(status: 'ACTIVE') }
  scope :trial, -> { where("status = 'TRIAL' OR (status = 'ACTIVE' AND trial_end_time > ?)", Time.now) }
  scope :active_or_trial, -> { where(status: ['TRIAL', 'ACTIVE']) }
  scope :real_active_or_trial, -> { where("status = 'TRIAL' OR (status = 'ACTIVE' AND trial_end_time > ?) OR (status = 'ACTIVE' AND (not_renew = 'f' OR not_renew IS NULL))", Time.now) }
  scope :real_active, -> { where("status = 'ACTIVE' AND (trial_end_time IS NULL OR trial_end_time < ?) AND (not_renew = 'f' OR not_renew IS NULL)", Time.now) }
  scope :active_not_renew, -> { where("status = 'ACTIVE' AND not_renew = 't'") }
  scope :suspended, -> { where(status: 'SUSPENDED') }
  scope :ready_to_suspend, -> { joins(:invoices).where("not_renew = 't' and suspended_in IS NULL invoices.", Time.now) }
  scope :active_to_user_app, -> { where("status IN ('ACTIVE', 'OVERDUE', 'TRIAL') OR next_invoice_date > ?", Time.now) }

  def ready_to_suspend?
    if self.not_renew and self.suspended_in.nil? and not self.suspended_in.present?
      invoices_paid_count = self.invoices.real_paid.count


      if self.user.voucher.present? or not self.user.plan.present?
        # franqueados
        plan_duration = ENV['FRANCHISEE_DEFAULT_PLAN_DURATION'].to_i
      else
        plan_duration = self.user.plan.duration
      end

      if invoices_paid_count % plan_duration == 0
        return true
      end

    end

    return false
  end

  # missing test
  def trial_period?
    return false if not self.trial_end_time.present?
    self.trial_end_time > Time.now
  end

  def active_period?
    return true if not self.trial_end_time.present?
    self.trial_end_time < Time.now
  end

  def set_first_paid_day_from_now
    if self.user.voucher.present? or not self.user.plan.present?
      # franqueados
      self.first_paid_day = ENV['FRANCHISEE_DEFAULT_TRIAL_DAYS'].to_i.days.from_now
    else
      self.first_paid_day = self.user.plan.trial_days.days.from_now
    end

    self.save
  end

  # not tested
  def created_on_moip?
    self.moip_code.present?
  end

  def calculate_suspend_in_and_active_until
    passed_days = Time.now - self.first_paid_day
    if passed_days < 0
      passed_days = 0
    end

    if self.user.voucher.present? or not self.user.plan.present?
      # franqueados
      plan_duration = ENV['FRANCHISEE_DEFAULT_PLAN_DURATION'].to_i
    else
      plan_duration = self.user.plan.duration
    end

    actual_cycle = (passed_days / plan_duration.months.to_f).floor + 1
    self.active_until = self.first_paid_day + (plan_duration * actual_cycle).month
    self.suspend_in = self.active_until - 10.days
    self.save
  end

  def get_status_pretty
    status_pretty = {
      'ACTIVE' => 'ativo',
      'SUSPENDED' => 'suspenso',
      'EXPIRED' => 'expirado',
      'OVERDUE' => 'pagamento atrasado',
      'CANCELED' => 'cancelado',
      'TRIAL' => 'teste',
    }

    begin
      return status_pretty[self.status]
    rescue Exception => e
      return 'desconhecido'
    end
  end

  def moip_attributes
    if self.voucher.present?
      plan_code = self.voucher.plan.code
    elsif self.user.voucher.present? or not self.user.plan.present?
      plan_code = ENV['FRANCHISEE_DEFAULT_MOIP_CODE']
    else
      plan_code = self.user.plan.moip_code
    end


    attrs = {
      code: Time.now.to_i,
      plan: {
        code: plan_code,
      },
      customer: {
        code: self.user.moip_code,
      },
    }

    if self.voucher.present?
      attrs.merge! amount: self.voucher.get_price_in_cents
    end

    if self.user.voucher.present?
      user_franchise = Franchisee.all.tagged_with(self.user.tags, any: true).where(token: self.user.voucher).first
      if user_franchise.present?
        attrs.merge! amount: ENV['FRANCHISEE_DEFAULT_PRICE'].to_i
      end
    end

    attrs
  end

  def update_from_moip data
    next_invoice_date = data['next_invoice_date']
    if next_invoice_date.present?
      self.next_invoice_date = Date.new(next_invoice_date['year'], next_invoice_date['month'], next_invoice_date['day'])
    end

    creation_date = data['creation_date']
    self.remote_creation_date = Date.new(creation_date['year'], creation_date['month'], creation_date['day'])

    self.status = data['status']

    if data['trial'].present?
      trial_start_time = data['trial']['start']
      self.trial_start_time = Date.new(trial_start_time['year'], trial_start_time['month'], trial_start_time['day'])

      trial_end_time = data['trial']['end']
      self.trial_end_time = Date.new(trial_end_time['year'], trial_end_time['month'], trial_end_time['day'])
    end

    self.save
  end

  def save_invoices invoices
    invoices.each do |invoice|
      invoice_model = self.invoices.where(moip_code: invoice['id']).first_or_create
      invoice_attributes = {
        status_code: invoice['status']['code'],
        status_description: invoice['status']['description'],
        occurrence: invoice['occurrence'],
        amount: invoice['amount'],
        subscription_code: invoice['subscription_code'],
      }
      invoice_model.update_attributes(invoice_attributes)

      invoice_model.creditation_date ||= Time.now
      invoice_model.save!
    end
  end
end
