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

require 'rails_helper'

RSpec.describe Subscription, type: :model do

  context "subscription and user mocked" do

    let(:user) {
      create(:user, {
        plan: plan
      })
    }

    let(:plan) {
      create(:plan, {
        duration: plan_duration,
        trial_days: plan_trial_days
      })
    }

    let(:plan_duration) { 1 }
    let(:plan_trial_days) { 7 }

    let!(:subscription) {
      create(:subscription, {
        not_renew: not_renew,
        suspended_in: suspended_in,
        user: user,
        active_until: active_until,
        first_paid_day: first_paid_day,
        next_invoice_date: next_invoice_date,
        status: status
      })
    }

    let(:not_renew) { nil }
    let(:active_until) { nil }
    let(:first_paid_day) { nil }
    let(:next_invoice_date) { 1.month.from_now }
    let(:suspended_in) { nil }
    let(:status) { 'ACTIVE' }

    subject { subscription }

    describe "active_to_user_app" do
      context 'ACTIVE' do
        let(:status) { 'ACTIVE' }

        it_behaves_like "an account active to user app"
      end

      context 'TRIAL' do
        let(:status) { 'TRIAL' }

        it_behaves_like "an account active to user app"
      end

      context 'OVERDUE' do
        let(:status) { 'OVERDUE' }

        it_behaves_like "an account active to user app"
      end

      context "next_invoice_date < Hoje" do
        let(:next_invoice_date) { 1.day.ago }

        context 'SUSPENDED' do
          let(:status) { 'SUSPENDED' }

          it_behaves_like "an account not active to user app"
        end

        context 'CANCELED' do
          let(:status) { 'CANCELED' }

          it_behaves_like "an account not active to user app"
        end

        context 'EXPIRED' do
          let(:status) { 'EXPIRED' }

          it_behaves_like "an account not active to user app"
        end
      end

      context "next_invoice_date > Hoje" do
        let(:next_invoice_date) { 1.day.from_now }

        context 'SUSPENDED' do
          let(:status) { 'SUSPENDED' }

          it_behaves_like "an account active to user app"
        end

        context 'CANCELED' do
          let(:status) { 'CANCELED' }

          it_behaves_like "an account active to user app"
        end

        context 'EXPIRED' do
          let(:status) { 'EXPIRED' }

          it_behaves_like "an account active to user app"
        end
      end

    end


    describe "set_first_paid_day_from_now" do
      it "sets from trial days after" do
        expect {
          subject.set_first_paid_day_from_now
        }.to change {
          subject.first_paid_day.to_i
        }.to plan_trial_days.days.from_now.to_i
      end
    end

    # describe "calculate_suspend_in_and_active_until" do

    #   let(:freeze_now) { Time.now }

    #   let(:first_paid_day) {
    #     freeze_now
    #   }

    #   context "mensal plan" do
    #     let(:plan_duration) { 1 }

    #     context "has passed 1 and half month" do

    #       it_behaves_like "suspendable in", (1.month + 15.days), 2.months
    #     end

    #     context "in trial period" do

    #       it_behaves_like "suspendable in", ( -5.days ), 1.months
    #     end
    #   end

    #   context "semestral plan" do
    #     let(:plan_duration) { 6 }

    #     it_behaves_like "suspendable in", (6.months + 30.days), 12.months
    #   end
    # end

    describe "ready_to_suspend" do

      let(:plan_duration) { 3 }

      context 'User with not_renew false' do
        it_behaves_like "a susbscription not ready to suspend"
      end

      context "with not not_renew true" do
        let(:not_renew) { true }

        context 'has not payed any invoices' do

          context 'has suspended_in' do
            let(:suspended_in) { Time.now }
            it_behaves_like "a susbscription not ready to suspend"
          end

          context 'has not suspended_in' do
            it_behaves_like "a susbscription ready to suspend"
          end
        end

        context 'has not payed total invoices' do

          before do
            create(:invoice, subscription: subject, amount: 0)
            create(:invoice, subscription: subject, amount: 1)
            create(:invoice, subscription: subject, amount: 1)
          end

          context 'has suspended_in' do
            let(:suspended_in) { Time.now }
            it_behaves_like "a susbscription not ready to suspend"
          end

          context 'has not suspended_in' do
            it_behaves_like "a susbscription not ready to suspend"
          end
        end

        context 'has payed total invoices' do

          before do
            create(:invoice, subscription: subject, amount: 0)
            create(:invoice, subscription: subject, amount: 1)
            create(:invoice, subscription: subject, amount: 1)
            create(:invoice, subscription: subject, amount: 1)
          end

          context 'has suspended_in' do
            let(:suspended_in) { Time.now }
            it_behaves_like "a susbscription not ready to suspend"
          end

          context 'has not suspended_in' do
            it_behaves_like "a susbscription ready to suspend"
          end
        end
      end

    end
  end


  describe "finders" do
    before do
      @subscription1 = create(:subscription, status: 'ACTIVE', trial_end_time: 1.day.ago)
      @subscription2 = create(:subscription, status: 'ACTIVE', not_renew: true, trial_end_time: 1.day.ago)
      @subscription3 = create(:subscription, status: 'TRIAL', trial_end_time: 1.day.from_now)
      @subscription4 = create(:subscription, status: 'SUSPENDED')
      @subscription5 = create(:subscription, status: 'ACTIVE', trial_end_time: 1.day.from_now)
    end

    it "returns real_active_or_trial" do
      expect(Subscription.real_active_or_trial).to match_array([@subscription1, @subscription3, @subscription5])
    end

    it "returns real_active" do
      expect(Subscription.real_active).to match_array([@subscription1])
    end

    # it "returns not_real_active" do
    #   expect(Subscription.not_real_active).to match_array([@subscription2])
    # end

    it "returns suspended" do
      expect(Subscription.suspended).to match_array([@subscription4])
    end

    it "returns trial" do
      expect(Subscription.trial).to match_array([@subscription3, @subscription5])
    end
  end
end
