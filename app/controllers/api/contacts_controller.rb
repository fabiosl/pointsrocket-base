module Api
  class ContactsController < Api::BaseController

    def create
      super
      ADMINS.each do |admin|
        TransactionalMailer.contactation_created(@contact, admin).deliver
      end
    end

    private

      def contact_params
        params.require(:contact).permit(:name, :email, :phone, :message)
      end

      def query_params
        params.permit(:email)
      end

  end
end
