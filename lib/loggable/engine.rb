module Loggable
  class Engine < ::Rails::Engine
    isolate_namespace Loggable
    config.autoload_paths << File.expand_path("../lib", __FILE__)
    config.autoload_paths << File.expand_path("../app/loggable", __FILE__)
    config.autoload_paths << File.expand_path("app/loggable", __FILE__)
  end
end
