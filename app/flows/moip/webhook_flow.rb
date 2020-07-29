module Moip::WebhookFlow

  class MoipInvoice
    class << self
      def update moip_code
        response = details moip_code
        if response[:success]
          invoice = Invoice.where(moip_code: moip_code).first_or_create
          invoice.update_from_moip response[:invoice]
        end
      end

      def details moip_code
        Moip::Assinaturas::Invoice.details moip_code
      end

      def send_mail moip_code
        invoice = Invoice.where(moip_code: moip_code).first
        if invoice
          mail_params = mail_details invoice
          mail_to = get_mail_to invoice
          if not mail_to.nil?
            send_mandril_mail mail_to, mail_params
          end
        end
      end

      def send_mandril_mail mail_to, mail_params
        TransactionalMailer.invoice_alert(mail_to, mail_params).deliver
      end

      def mail_details invoice
        {
          'ID' => invoice.id,
          'STATUS_DESCRIPTION' => invoice.status_description,
        }
      end

      def get_mail_to invoice
        if invoice.subscription and invoice.subscription.user
          [invoice.subscription.user.email]
        else
          nil
        end
      end
    end
  end

  class MoipSubscription
    class << self
      def update moip_code
        response = details moip_code
        if response[:success]
          subscription = Subscription.where(moip_code: moip_code).first_or_create
          subscription.update_from_moip response[:subscription]
        end
      end

      def details moip_code
        Moip::Assinaturas::Subscription.details moip_code
      end

      def send_mail moip_code
        subscription = Subscription.where(moip_code: moip_code).first
        if subscription
          mail_params = mail_details subscription
          mail_to = get_mail_to subscription
          if not mail_to.nil?
            send_mandril_mail mail_to, mail_params
          end
        end
      end

      def send_mandril_mail mail_to, mail_params
        TransactionalMailer.subscription_alert(mail_to, mail_params).deliver
      end

      def mail_details subscription
        {
          'ID' => subscription.id,
          'STATUS_DESCRIPTION' => subscription.get_status_pretty,
        }
      end

      def get_mail_to subscription
        if subscription.user
          [subscription.user.email]
        else
          nil
        end
      end
    end
  end

  class MoipPayment
    class << self
      def details moip_code
        Moip::Assinaturas::Payment.details moip_code
      end

      def send_mail moip_code
        response = details moip_code

        if response[:success]
          payment_details = response[:payment]
          subscription = Subscription.where(moip_code: payment_details['subscription_code']).first_or_create
          invoice = subscription.invoices.where(moip_code: payment_details['invoice']['id']).first_or_create

          mail_params = mail_details response[:payment], invoice
          mail_to = get_mail_to invoice

          if not mail_to.nil?
            send_mandril_mail mail_to, mail_params
          end
        end

      end

      def send_mandril_mail mail_to, mail_params
        TransactionalMailer.payment_alert(mail_to, mail_params).deliver
      end

      def mail_details payment_details, invoice

        {
          'MOIP_PAYMENT_ID' => payment_details['id'],
          'INVOICE_ID' => invoice.id,
          'STATUS_DESCRIPTION' => payment_details['status']['description'],
        }
      end

      def get_mail_to invoice
        if invoice.subscription and invoice.subscription.user
          [invoice.subscription.user.email]
        else
          nil
        end
      end
    end
  end
end
