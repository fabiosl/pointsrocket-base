require 'rabl'
require "trivias/engine"
require "trivias/create"

module Trivias

  # User class for trivia
  # Usage:
  #   Trivias.user_class = 'User'
  mattr_accessor :user_class

  def self.user_class
    @@user_class.constantize
  end

  # The parent controller all Trivias controllers inherits from.
  # Defaults to ApplicationController. This should be set early
  # in the initialization process and should be set to a string.
  mattr_accessor :parent_controller
  @@parent_controller = "ApplicationController"

  def self.parent_controller
    @@parent_controller.constantize
  end

end
