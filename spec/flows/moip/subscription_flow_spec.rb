require 'rails_helper'

RSpec.describe Moip::SubscriptionFlow do

  context "create on moip returning some id" do
    before do
      user = create(:user, moip_code: 123123)
      @subscription = create(:subscription, user: user)

      user_without_moip_code = create(:user)
      @subscription_without_user_moip_code = create(:subscription, user: user_without_moip_code)
    end

    before do
      allow_any_instance_of(described_class).to receive(:create_on_moip).and_return({
        success: true,
      })
      allow_any_instance_of(described_class).to receive(:details).and_return({
        success: true,
        subscription: {
          "creation_date"=>{"minute"=>40, "second"=>28, "month"=>8, "year"=>2015, "hour"=>14, "day"=>7},
          "amount"=>3990, "plan"=>{"name"=>"Anual", "code"=>"anual"}, "status"=>"TRIAL",
          "next_invoice_date"=>{"month"=>8, "year"=>2015, "day"=>15}, "code"=>"1438969227",
          "customer"=>{"email"=>"gustavo@costabraga.biz", "code"=>"2015-08-07-14-40-24-03001", "fullname"=>"Esther Melo"},
          "trial"=>{"start"=>{"month"=>8, "year"=>2015, "day"=>7}, "end"=>{"month"=>8, "year"=>2015, "day"=>14}}
        }
      })
    end

    describe "create" do
      it "saves moip subscription id" do
        expect {
          described_class.new(@subscription).create
        }.to change {
          @subscription.moip_code
        }
      end

      it "saves moip next invoice date" do
        expect {
          described_class.new(@subscription).create
        }.to change {
          @subscription.next_invoice_date.to_i
        }
      end

      it "saves moip status" do
        expect {
          described_class.new(@subscription).create
        }.to change {
          @subscription.status
        }.to('TRIAL')
      end

      it "saves trial start time" do
        expect {
          described_class.new(@subscription).create
        }.to change {
          @subscription.trial_start_time
        }
      end

      it "saves trial end time" do
        expect {
          described_class.new(@subscription).create
        }.to change {
          @subscription.trial_start_time
        }
      end

      it "saves remote_creation_date" do
        expect {
          described_class.new(@subscription).create
        }.to change {
          @subscription.trial_start_time
        }
      end
    end

    context "get_and_save_moip_invoices" do
      before do
        allow_any_instance_of(described_class).to receive(:get_moip_invoices).and_return({success: true, invoices: [
          {"amount"=>0, "creation_date"=>{"minute"=>16, "second"=>5, "month"=>8, "year"=>2015, "hour"=>23, "day"=>7}, "id"=>6273127, "status"=>{"description"=>"Pago", "code"=>3}, "subscription_code"=>"1439000165", "occurrence"=>1}
        ]})
      end

      it "saves invoices" do
        expect {
          described_class.new(@subscription).get_and_save_moip_invoices
        }.to change {
          Invoice.count
        }.by(1)
      end
    end

  end

  context "create on moip returning some id withou user moip code" do
    describe "create" do
      it "raises Moip::InvalidSubscriptionError" do
        expect {
          described_class.new(@subscription_without_user_moip_code).create
        }.to raise_error
      end
    end
  end

  context "with details" do
    before do
      @subscription = create(:subscription)
      @params = {:success=>true, :subscription=>{"creation_date"=>{"minute"=>15, "second"=>22, "month"=>8, "year"=>2015, "hour"=>22, "day"=>8}, "amount"=>3990, "plan"=>{"name"=>"Anual", "code"=>"anual"}, "status"=>"TRIAL", "next_invoice_date"=>{"month"=>8, "year"=>2015, "day"=>16}, "code"=>"1439082921", "customer"=>{"email"=>"hlio@martinsoliveira.net", "code"=>"2015-08-08-22-15-18-03001", "fullname"=>"Guilherme Costa"}, "trial"=>{"start"=>{"month"=>8, "year"=>2015, "day"=>8}, "end"=>{"month"=>8, "year"=>2015, "day"=>15}}}}
      allow_any_instance_of(described_class).to receive(:details).and_return(@params)
    end

    context "update_details_from_moip" do
      it "call save from moip" do
        expect(@subscription).to receive(:update_from_moip).with(@params[:subscription]).once
        described_class.new(@subscription).update_details_from_moip
      end
    end

  end

  # describe "activate" do
  #   before do
  #     @subscription = create(:subscription, moip_code: 1439082921)
  #   end

  #   it "returns ok" do
  #     response = described_class.new(@subscription).activate
  #     expect(response[:success]).to be_truthy
  #   end
  # end

  # describe "suspend" do
  #   before do
  #     @subscription = create(:subscription, moip_code: 1439082921)
  #   end

  #   it "returns ok" do
  #     response = described_class.new(@subscription).suspend
  #     expect(response[:success]).to be_truthy
  #   end
  # end

  # describe "details" do
  #   before do
  #     @subscription = create(:subscription, moip_code: 1439082921)
  #   end

  #   it "returns ok" do
  #     response = described_class.new(@subscription).details
  #     expect(response[:success]).to be_truthy
  #   end
  # end

  context "create" do
    let(:plan) {
      create(:plan, moip_code: ENV['MOIP_PLAN_CODE'])
    }

    let(:user) {
      create(:user, plan: plan, cpf: '09571458457')
    }

    # context "with valid credit_card number, but invalid fields" do
    #   let(:credit_card) {
    #     create(
    #       :credit_card, user: user,
    #       number: '5162-3075-1333-9947',
    #       holder_name: 'Manoel Q Neto',
    #       expiration: '10/16',
    #     )
    #   }

    #   before do
    #     @subscription = create(:subscription, user: user)
    #     moip_client_flow = Moip::ClientFlow.new(user)
    #     moip_client_flow.create
    #     moip_client_flow.update_credit_card({credit_card: credit_card.moip_attributes})
    #   end

    #   it "creates correctly on moip" do
    #     response = described_class.new(@subscription).create
    #     expect(response[:success]).to be_truthy
    #   end
    # end

    context "with invalid credit_card number, but invalid fields" do
      let(:credit_card) {
        create(
          :credit_card, user: user,
          number: '4539-7668-8708-0081',
          holder_name: 'Manoel Q Neto',
          expiration: '10/16',
        )
      }

      before do
        @subscription = create(:subscription, user: user)
        moip_client_flow = Moip::ClientFlow.new(user)
        moip_client_flow.create
        moip_client_flow.update_credit_card({credit_card: credit_card.moip_attributes})
      end

      it "creates correctly on moip" do
        response = described_class.new(@subscription).create
        expect(response[:success]).to be_truthy
      end
    end
  end
end
