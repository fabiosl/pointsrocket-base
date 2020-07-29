module Api
  class BadgesController < Api::BaseController
    before_filter :authenticate_user!
    skip_before_action :verify_authenticity_token

    def index
      @badges = Badge.all
    end

    def create
      super
      @badge.save
    end

    private

    def badge_params
      the_params = params.require(:badge).permit(
        :id,
        :name,
        :badge_type,
        :hint,
        :badge_points,
        :avatar,
      )

      the_params
    end

    def query_params
      params.permit(:email)
    end
  end
end
