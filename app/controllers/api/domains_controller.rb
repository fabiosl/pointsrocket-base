module Api
  class DomainsController < Api::BaseController
    include HowToPointItemHelper
    before_filter :authenticate_user!
    skip_before_filter :authenticate_user!, only: [:current]
    skip_before_action :verify_authenticity_token

    def current
      @for_world = true
      @domain = Domain.get_current_domain
      render :show
    end

    def self
      @domain = Domain.get_current_domain
      render :show
    end

    def index
      @domains = Domain.all
    end

    def create
      super

      if @domain.persisted?
        @domain.save
      end
    end

    private

      def domain_params
        the_params = params.require(:domain).permit(
          :id,
          :name,
          :url,
          :description,
          :default,
          :dashboard_image_down,
          :delete_dashboard_image_down,
          :dashboard_menu_image,
          :delete_dashboard_menu_image,
          :dashboard_login_image,
          :delete_dashboard_login_image,
          :dashboard_menu_image_contract,
          :delete_dashboard_menu_image_contract,
          :employee_advocacy_email_logo_image,
          :delete_employee_advocacy_email_logo_image,
          :employee_advocacy_enabled,
          :only_registered_hashtags,
          :dashboard_enabled,
          :courses_enabled,
          :forum_enabled,
          :facebook_app_id,
          :facebook_app_secret,
          :twitter_app_id,
          :twitter_app_secret,
          :youtube_app_id,
          :youtube_app_secret,
          :instagram_app_id,
          :instagram_app_secret,
          :linkedin_app_id,
          :linkedin_app_secret,
          :after_signin_path,
          :css,
          :css_text,
          :is_points,
          :has_indication,
          :layout,
          :has_homepage,
          :challenges_enabled,
          :hashtag_challenges_enabled,
          :broadcasts_enabled,
          :campaigns_enabled,
          :peer_recognition_enabled,
          :any_user_can_post,
          :pass_domains_select_and_log_here_directly,
          :only_invited,
          :from_mail,
          :challenge_localize_key,
          :login_terms_url,
          :apn_key,
          :remove_apn_key,
          :social_network_permiteds,
          :android_api_key,
          :login_providers,
          :weekly_user_coins,
          :peer_recognition_hashtags,
          :advocacy_posts_limit_by_day,
          :share_in_personal,
          :share_in_fanpage,
          :for_submission,
          :domain_br_badge_events_attributes => [
            :id,
            :event,
            :br_badge,
            :_destroy
          ],
          :how_to_point_items_attributes => how_to_point_item_permitted_params_fields
        )

        the_params
      end

  end
end
