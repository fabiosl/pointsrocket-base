class DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_if_user_has_submited_payment_form!
  before_filter :set_search_query
  before_action :check_domain_access
  before_action :create_membership

  helper_method :get_course_status, :get_course_percents
  include DashboardHelper

  layout 'dashboard'

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.unauth_url(type: 'unallowed')
  end

  def index
    if can?(:see_courses, @domain)
      @courses = Course.active
      @courses_comming_soon = Course.comming_soon
      # render 'dashboard/index'
    else
      # redirect_to after_sign_in_path_for(current_user)
    end
    # render 'dashboard/index'
  end

  def dashboard
    authorize! :see_dashboard, @domain
    @leaderboard = LeaderboardFlow.new.get("daily")
    @points_evolution = PointsEvolutionFlow.new(current_user).get(
      "this_month", "weekly"
    )
    @questions = Question.all.order('created_at desc').limit(5)
    @courses_info = UserCourseFlow.new(current_user).info
    @badge_users = BadgesFlow.new(current_user).last(5)
    @rewards = RewardsFlow.new(current_user).info
    @goals_info = GoalsFlow.new.info(current_user.tags)
  end

  def blocked_content
    Rails.logger.info "Evento importante: Usuário #{current_user.name} #{current_user.email} #{current_user.phone} chegou na tela de conteúdo restrito pra assinantes"
  end

  def chapter
    render layout: 'chapter'
  end

  def process_search_query_result itens
    itens
  end

  private

  def set_search_query
    @search_query = Search::Item.ransack(params[:q])
  end

  def user_params
    params.require(:user).permit(
      :name, :avatar, :delete_avatar, :location, :website, :bio, :username,
      :lang, :timezone, :country, :see_sensitive_media, :mark_sensitive_media,
      :current_password, :password, :password_confirmation, :renew, :cancel_reason,
      :email, :locale, :phone, :interest_category_list => [],
      :interest_topic_list => []
    )
  end

  def get_course_status(course_id)

  end

  def check_if_user_has_submited_payment_form!
    has_all_data = current_user.phone.present? and current_user.birthdate.present?
    if not has_all_data and not current_user.has_submited_payment_form and not @domain.is_points
      redirect_to complete_registration_index_path
    end
  end

  def get_course_percents(course_id)
    return 0
  end

  def check_domain_access
    if ENV['SUBDOMAIN_AS_COMMUNITIES'] == 'true'
      return if current_user.admin || current_user.in_domain?(@domain)
      flash[:alert] = I18n.t('controllers.dashboard.no_access')
      redirect_to domains_url(subdomain: false)
    end
  end

  def create_membership
    current_user.create_membership! @domain
  end
end
