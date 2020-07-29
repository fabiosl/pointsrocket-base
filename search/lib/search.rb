require "orm_adapter"
require "search/engine"

module Search
  # The parent controller all Trivias controllers inherits from.
  # Defaults to ApplicationController. This should be set early
  # in the initialization process and should be set to a string.
  mattr_accessor :parent_controller
  @@parent_controller = "ApplicationController"

  def self.parent_controller
    @@parent_controller.constantize
  end

  mattr_accessor :registered_models
  @@registered_models = []

  def self.register_model model
    @@registered_models << model
  end
end

require 'search/models'
require 'search/orm/active_record'
