class OmniauthSetup
  include Rails.application.routes.url_helpers

  # OmniAuth expects the class passed to setup to respond to the #call method.
  # env - Rack environment
  def self.call(env)
    new(env).setup
  end

  def current_domain request
    @domain ||= Domain.find_by(subdomain: Apartment::Tenant.current) ||
                Domain.find_by(url: request.protocol + request.host_with_port) ||
                Domain.find_by(default: true)

  end

  def http_host
    return "#{@env["rack.url_scheme"]}://#{@env['HTTP_HOST']}"
  end

  # Assign variables and create a request object for use later.
  # env - Rack environment
  def initialize(env)
    @env = env
    @request = ActionDispatch::Request.new(env)
  end

  # The main purpose of this method is to set the consumer key and secret.
  def setup
    @env['omniauth.strategy'].options.merge!(custom_credentials)
  end

end
