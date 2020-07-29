module Api
  class ReservasController < Api::BaseController

    def create
      super
      ADMINS.each do |admin|
        TransactionalMailer.reservation_created(@reserva, admin).deliver
      end
    end

    private

      def reserva_params
        params.require(:reserva).permit(:name, :email, :phone, :curso_landing_id)
      end

      def query_params
        params.permit(:email)
      end

  end
end
