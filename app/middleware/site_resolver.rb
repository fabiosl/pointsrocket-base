
class SiteResolver

  def initialize app
    @app = app
  end

  def call env
    dup._call env
  end

  def _call env
    request = ::Rack::Request.new(env)
    url = request.base_url

    begin
      EnvSkipper.skip env
    rescue EnvSkipper::SkipException => e
      return @app.call(env)
    end

    # to do, don`t hardcoded this check
    skipable = request.path.starts_with?('/admin') || request.path.starts_with?('/uploads')

    if not skipable
      if domain = ::DomainService.get_domain_by_url(url) # DomainService is returning the expected value
        request.update_param('current_domain_id', domain.id)
      end
    end
    return @app.call(request.env)
  end

end
