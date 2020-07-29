module Api
  class NewslettersController < Api::BaseController

    def create
      super
      ADMINS.each do |admin|
        TransactionalMailer.newsletter_created(@newsletter, admin).deliver
      end
    end

    private

      def newsletter_params
        params.require(:newsletter).permit(:email, :name)
      end

      def query_params
        params.permit(:email)
      end

  end
end
