require 'loggable/version'
require 'loggable/integration'
require 'loggable/logger'

require 'yell'
require 'active_support/all'

module Loggable
  class << self
    def setup
      @loggable ||= begin
        loggable = YAML.load_file("config/loggable.yml")
        loggable['loggers'] = []
        loggable['logs'].each do |name, logger|
          loggable['loggers'] << name
          define_singleton_method(name) do
            if @loggable['aliases'][name]
              @loggable['aliases'][name]
            else
              @loggable[name]
            end
          end
          loggable[name] = Yell.new(name: name) do |l|
            l.adapter :file, logger['file'], level: logger['level']
          end
        end
        loggable
      end
    end
  end
end

Loggable.setup
