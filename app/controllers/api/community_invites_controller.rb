module Api
  class CommunityInvitesController < Api::BaseController
    before_action :set_resource, except: [:index]

    include ControllerApiDomainHelper
    include CommunityInvitesHelper
  
  
    def index
      authorize! :manage_community, current_domain
      @community_invites = CommunityInvite.where(domain: current_domain)
                                          .order(status: :desc)
    end

    def approve
      if @community_invite.approve_with_role(params[:role])
        message = I18n.t('controllers.dashboard.community_invites.approve.success')
        render(
          json: @community_invite, serializer: CommunityInviteSerializer,
          status: :ok
        )
      else
        message = I18n.t('controllers.dashboard.community_invites.approve.error')
        render(
          json: { errors: @community_invite.errors.full_messages, message: message },
          status: :unprocessable_entity
        )
      end
    end

    def decline
      if @community_invite.update(status: :declined)
        message = I18n.t('controllers.dashboard.community_invites.decline.success')
        render(
          json: @community_invite, serializer: CommunityInviteSerializer,
          status: :ok
        )
      else
        message = I18n.t('controllers.dashboard.community_invites.decline.error')
        render(
          json: { errors: @community_invite.errors.full_messages, message: message },
          status: :unprocessable_entity
        )
      end
    end
  end
end
