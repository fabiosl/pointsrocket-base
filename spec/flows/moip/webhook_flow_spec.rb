require 'rails_helper'

RSpec.describe Moip::WebhookFlow do

  before do
    @subscription = create(:subscription, moip_code: 1439154476)
    @invoice = create(:invoice, subscription: @subscription, moip_code: 6315904)
  end

  context "MoipInvoice" do

    before do
      allow(described_class::MoipInvoice).to receive(:details).and_return(
        {:success=>true, :invoice=>{"amount"=>0, "creation_date"=>{"minute"=>7, "second"=>57, "month"=>8, "year"=>2015, "hour"=>18, "day"=>9}, "id"=>6315904, "plan"=>{"name"=>"Anual", "code"=>"anual"}, "items"=>[{"amount"=>0, "type"=>"Período de trial"}], "status"=>{"description"=>"Pago", "code"=>3}, "subscription_code"=>"1439154476", "occurrence"=>1, "customer"=>{"code"=>"2015-08-09-18-07-55-03001", "fullname"=>"Warley Moraes"}}}
      )
    end

    describe "#update" do
      it "updates invoice" do
        described_class::MoipInvoice.update(6315904)
        expect(Invoice.find(@invoice.id).status_code).to eql(3)

        # expect {
        #   described_class::MoipInvoice.update(6315904)
        # }.to change {
        #   @invoice.status
        # }
      end

      it "creates invoice" do
        expect {
          described_class::MoipInvoice.update(6315751)
        }.to change {
          @subscription.invoices.count
        }.by(1)
      end
    end

    describe "#send_mail" do
      before do
        described_class::MoipInvoice.update(6315751)
      end

      context "mail mocked" do
        before do
          @deliver_double = double()
          allow(@deliver_double).to receive(:deliver).and_return(true)
        end

        it "retrieve emails correctly" do
          expect_any_instance_of(TransactionalMailer).to(
            receive(:invoice_alert).once().and_return(@deliver_double)
          )
          described_class::MoipInvoice.send_mail(6315751)
        end
      end

      # context "real test" do
      #   it "suceeds" do
      #     described_class::MoipInvoice.send_mail(6315751)
      #   end
      # end
    end
  end


  context "MoipSubscription" do

    before do
      allow(described_class::MoipSubscription).to receive(:details).and_return(
        {:success=>true, :subscription=>{"creation_date"=>
          {"minute"=>14, "second"=>53, "month"=>8, "year"=>2015, "hour"=>11, "day"=>9},
          "amount"=>3990, "plan"=>{"name"=>"Anual", "code"=>"anual"}, "status"=>"SUSPENDED",
          "code"=>"1439129692", "customer"=>{"email"=>"danilo_pereira@costa.com", "code"=>"2015-08-09-11-14-50-03001", "fullname"=>"Janaína Carvalho"}, "trial"=>{"start"=>{"month"=>8, "year"=>2015, "day"=>9}, "end"=>{"month"=>8, "year"=>2015, "day"=>16}}}}
      )
    end

    describe "#update" do
      it "updates subscription" do
        described_class::MoipSubscription.update(1439154476)
        expect(Subscription.find(@subscription.id).status).to eql("SUSPENDED")

        # expect {
        #   described_class::MoipSubscription.update(1439129692)
        # }.to change {
        #   @subscription.status
        # }
      end

    end

    describe "#send_mail" do
      before do
        subscription = create(:subscription, moip_code: 1439129692)
        described_class::MoipSubscription.update(1439129692)
      end

      context "mail mocked" do
        before do
          @deliver_double = double()
          allow(@deliver_double).to receive(:deliver).and_return(true)
        end

        it "retrieve emails correctly" do
          expect_any_instance_of(TransactionalMailer).to(
            receive(:subscription_alert).once().and_return(@deliver_double)
          )
          described_class::MoipSubscription.send_mail(1439129692)
        end
      end

      # context "real test" do
      #   it "suceeds" do
      #     described_class::MoipSubscription.send_mail(1439129692)
      #   end
      # end
    end
  end


  context "MoipPayment" do

    before do
      allow(described_class::MoipPayment).to receive(:details).and_return(
        {:success=>true,
          :payment=>{
            "creation_date"=>{"minute"=>36, "second"=>14, "month"=>8, "year"=>2015, "hour"=>1, "day"=>14
            }, "id"=>6421688, "customer_code"=>"2015-08-06-15-18-32-03001",
            "status"=>{"description"=>"Cancelado", "code"=>5},
            "subscription_code"=>"1438885112",
            "moip_id"=>1439526974,
            "invoice"=>{"amount"=>10000, "id"=>6423015},
            "payment_method"=>{"description"=>"Cartão de Crédito",
            "credit_card"=>{
              "holder_name"=>"Feliciano Macedo",
              "first_six_digits"=>"122812", "expiration_month"=>"08",
              "brand"=>"VISA", "expiration_year"=>"17", "last_four_digits"=>"1431"},
              "code"=>1
            }
          }
        }
      )
    end

    describe "#send_mail" do
      before do
        subscription = create(:subscription, moip_code: 1438885112)
      end

      context "mail mocked" do

        before do
          @deliver_double = double()
          allow(@deliver_double).to receive(:deliver).and_return(true)
        end

        it "retrieve emails correctly" do
          expect_any_instance_of(TransactionalMailer).to(
            receive(:payment_alert).once().and_return(@deliver_double)
          )
          described_class::MoipPayment.send_mail(6421688)
        end
      end

      # context "real test" do
      #   it "suceeds" do
      #     described_class::MoipPayment.send_mail(6421688)
      #   end
      # end
    end
  end



  context "MoipInvoice no mocked" do

    describe "#update" do
      it "updates invoice" do
        described_class::MoipSubscription.update(6315920412312)
        described_class::MoipSubscription.send_mail(6315920412312)
        # expect(Invoice.find(@invoice.id).status_code).to eql(3)
      end

      # it "creates invoice" do
      #   expect {
      #     described_class::MoipSubscription.update(631512312751)
      #   }.to change {
      #     @subscription.invoices.count
      #   }.by(1)
      # end
    end
  end
end
