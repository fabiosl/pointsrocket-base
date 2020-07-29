module Trivias
  class Engine < ::Rails::Engine
    isolate_namespace Trivias

    initializer :trivias do
      if defined? ActiveAdmin
        ActiveAdmin.application.load_paths += Dir[File.dirname(__FILE__) + '/admin']
      end
    end

    config.to_prepare do
      Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end
  end
end
