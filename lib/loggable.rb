require 'yell'
module Loggable
  class << self
    def setup
      @loggable ||= begin
        loggable = YAML.load_file("config/loggable.yml")
        puts "loggable.yml: #{loggable.inspect}"
        loggable['loggers'] = []
        loggable['logs'].each do |name, logger|
          puts "#{name}: #{logger.inspect}"
          loggable['loggers'] << name
          loggable[name] = Yell.new(name: name) do |l|
            l.adapter :file, logger['file'], level: logger['level']
          end
        end
        loggable
      end
      @defined ||= begin
        @loggable['loggers'].each do |name|
          define_singleton_method(name) do
            if @loggable['aliases'][name]
              @loggable['aliases'][name]
            else
              @loggable[name]
            end
          end
        end
        true
      end
    end
  end
end

Loggable.setup
