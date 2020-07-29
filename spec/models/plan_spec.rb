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

require 'rails_helper'

RSpec.describe Plan, type: :model do

  describe ".get_current_plan" do
    subject { described_class.get_current_plan }

    before do
      Plan.destroy_all
    end

    context "with no plan" do
      it { is_expected.to be_nil }
    end

    context "with plan with moip_code" do
      before do
        # something is creating a plan
        Plan.destroy_all
        create(:plan, moip_code: 'monthly')
        @plan = create(:plan, moip_code: ENV['MOIP_PLAN_CODE'])
      end

      subject { described_class.get_current_plan }

      it { is_expected.to eql(@plan) }
    end

    context "with plan without moip_code" do
      before do
        Plan.destroy_all
        create(:plan, moip_code: 'monthly')
        create(:plan, moip_code: 'daily')
      end

      subject { described_class.get_current_plan }

      it { is_expected.to eql(Plan.first) }
    end
  end

end
