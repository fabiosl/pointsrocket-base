module Api
  class PlansController < Api::BaseController
    include PlansHelper
    include ControllerApiDomainHelper
  end
end
