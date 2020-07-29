class IndexController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def index

    if @domain.present? and not @domain.has_homepage
      redirect_to new_user_session_path and return
    end

    if params['i']
      session[:indicator_id] = params['i']
    end

    @curso_landings = CursoLanding.all.order('active desc')
    @plans = Plan.active.order('duration asc')

    if @domain.present? and @domain.layout.present?
      render layout: @domain.layout
    end
  end

end
