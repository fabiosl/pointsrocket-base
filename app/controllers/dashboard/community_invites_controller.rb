class Dashboard::CommunityInvitesController < DashboardController
  before_action :set_community_invite, except: [:index, :create]
  skip_before_action :check_domain_access

  def index
    authorize! :manage_community, current_domain
    @community_invites = CommunityInvite.where(domain: current_domain)
                                        .order(status: :desc)
  end

  def create
    community_invite = CommunityInvite.new(
      user: current_user,
      domain_id: params[:domain_id],
      status: :waiting_approval
    )

    if community_invite.save
      flash[:success] = I18n.t('controllers.dashboard.community_invites.create.success')
    else
      flash[:error] = I18n.t('controllers.dashboard.community_invites.create.error')
    end

    redirect_to domains_path
  end

  def approve
    if @community_invite.approve_with_role(params[:role])
      flash[:success] = I18n.t('controllers.dashboard.community_invites.approve.success')
    else
      flash[:error] = I18n.t('controllers.dashboard.community_invites.approve.error')
    end
    redirect_to community_invites_path
  end

  def decline
    if @community_invite.update(status: :declined)
      flash[:success] = I18n.t('controllers.dashboard.community_invites.decline.success')
    else
      flash[:danger] = I18n.t('controllers.dashboard.community_invites.decline.error')
    end

    redirect_to community_invites_path
  end

  private

  def set_community_invite
    @community_invite = CommunityInvite.find(params[:id])
  end
end
