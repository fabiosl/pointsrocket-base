class MoipHookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    Rails.logger.info "webhook result params #{params.to_json}"
    resource = params['moip_hook']['resource']

    resultado = Moip::Assinaturas::Webhooks.listen(request) do |hook|

      hook.on(:payment, [:created, :status_updated]) do
        Moip::WebhookFlow::MoipPayment.send_mail(resource['id'] || resource['code'])
      end

      hook.on(:invoice, [:created, :status_updated]) do
        Moip::WebhookFlow::MoipInvoice.update(resource['id'] || resource['code'])
        Moip::WebhookFlow::MoipInvoice.send_mail(resource['id'] || resource['code'])
      end

      hook.on(:subscription, [:created, :activated, :suspended]) do
        Moip::WebhookFlow::MoipSubscription.update(resource['id'] || resource['code'])
        Moip::WebhookFlow::MoipSubscription.send_mail(resource['id'] || resource['code'])
      end

      # hook para capturar eventos que ainda não são explicitamente tratados
      hook.missing do |model, event|
        Rails.logger.warn "Não encontrado hook para o modelo #{model} e evento #{event}"
        false
      end
    end

    render :text => "done ok" and return if resultado
    render nothing: true, status: :bad_request
  end
end
