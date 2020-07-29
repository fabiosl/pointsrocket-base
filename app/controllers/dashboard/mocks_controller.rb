class Dashboard::MocksController < DashboardController

  def analytics
    @has_error = false
    @period = params["period"]
    @start_date = false
    @end_date = false

    begin
      @period, @start_date, @end_date = AnalyticsInfo.get_correct_period_and_validate_start_and_end_date params["period"], params["start_date"], params["end_date"]
    rescue Exception => e
      @has_error = true
      flash.now[:warning] = e.message
    end

    begin
      FacebookHelper.get_access_token(current_user, @domain)
    rescue FacebookHelper::NoIdentityFound => e
      @has_no_fb_account = true
    end

    begin
      GoogleHelper.authorization_for_user(current_user, @domain)
    rescue GoogleHelper::NoIdentityFound => e
      @has_no_yt_account = true
    end


  end

end
