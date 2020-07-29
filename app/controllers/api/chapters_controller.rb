module Api
  class ChaptersController < Api::BaseController
    before_filter :authenticate_user!
    before_action :set_course
    skip_before_action :verify_authenticity_token

    def index
      @chapters = @course.chapters
    end

    def create
    end

    private

      def contact_params
        params.require(:course).permit(:name, :email, :phone, :message)
      end

      def query_params
        params.permit(:email)
      end

      def set_domain
        @domain = Domain.find params[:domain_id]
      end

      def set_course
        @course = Course.all.find params[:course_id]
      end

  end
end
