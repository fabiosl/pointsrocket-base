class LastAccess

  def initialize app
    @app = app
  end

  def call env
    dup._call env
  end

  def _call env
    # return @app.call(env)
    status = nil
    headers = nil
    response = nil

    begin
      ::EnvSkipper.skip env
    rescue ::EnvSkipper::SkipException => e
      return @app.call(env)
    end

    begin
      current_user_id = env["rack.session"]["warden.user.user.key"].first.first
      current_domain = Domain.find env["rack.session"]["current_domain_id"]

      Apartment::Tenant.switch(current_domain.subdomain) do
        user = User.find(current_user_id)
        user.last_access = Time.now

        if user.next_youtube_collect.present? and user.next_youtube_collect > 5.minutes.from_now
          user.next_youtube_collect = Time.now
        end

        if user.next_facebook_collect.present? and user.next_facebook_collect > 5.minutes.from_now
          user.next_facebook_collect = Time.now
        end

        if user.next_instagram_collect.present? and user.next_instagram_collect > 5.minutes.from_now
          user.next_instagram_collect = Time.now
        end
        user.save
      end

    rescue Exception => e
    end

    @app.call(env)
  end

end
