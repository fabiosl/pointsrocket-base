module ControllerMacros

  def create_default_domain
    @domain = FactoryGirl.create(:domain, default: true, subdomain: "default")
  end

end

RSpec.configure do |config|
  config.include ControllerMacros, :type => :controller
end
