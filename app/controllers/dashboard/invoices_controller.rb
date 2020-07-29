class Dashboard::InvoicesController < DashboardController
  layout 'dashboard'

  def index
    @credit_cards = current_user.credit_cards
    @invoices = current_user.invoices.order('creditation_date desc')
  end

end
