require "loggable/version"
require "loggable/engine"
require "loggable/integration"
require "loggable/message"
require "loggable/logger"

require "yell"
require "active_support/all"

module Loggable
  class << self
    def config
      @loggable
    end

    def plugins
      config["plugins"] || []
    end

    def setup
      @loggable ||= begin
          loggable = YAML.load_file("config/loggable.yml")
          loggable["loggers"] = []
          loggable["logs"].each do |name, logger|
            loggable["loggers"] << name
            define_singleton_method(name) do
              @loggable[name]
            end
            if logger["file"].present?
              loggable[name] = Yell.new(name: name) do |l|
                l.adapter :file, logger["file"], level: logger["level"]
              end
            else
              loggable[name] = Yell.new(name: name) do |l|
                l.adapter STDOUT, level: [:info, :warn]
                l.adapter STDERR, level: [:error, :fatal]
              end
            end
          end
          loggable["aliases"].each do |name, to|
            define_singleton_method(name) do
              @loggable[to]
            end
          end
          loggable
        end
    end
  end
end

Loggable.setup
