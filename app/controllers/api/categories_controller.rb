module Api
  class CategoriesController < Api::BaseController
    include CategoriesHelper
    include ControllerApiDomainHelper
  end
end
