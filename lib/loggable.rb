module Loggable
  class << self

    private

    def setup
      @loggable ||= begin
        loggable = YAML.load_file("config/loggable.yml")
        loggable['loggers'] = []
        loggable['logs'].each do |name, logger|
          loggable['loggers'] << name
          loggable[name] = Yall.new do |l|
            l.level = logger['level'] if logger['level']
            l.adapter :file, logger['file'], level: logger['level']
          end
        end
        loggable
      end
      @defined ||= begin
        @loggable['loggers'].each do |name|
          define_method(name) do
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
