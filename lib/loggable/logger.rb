module Loggable::Logger
  extend ActiveSupport::Concern
  included do
    def debug(message, options={})
      _log(:debug, message, options)
    end
    def info(message, options={})
      _log(:info, message, options)
    end
    def warn(message, options={})
      _log(:info, message, options)
    end
    def error(message, options={})
      _log(:info, message, options)
    end

    private

    def _log(level, message, options)
      _logger.send(level, message)
      self.class.integration(:faye, level, message) if options[:faye]
      self.class.integration(:plex, level, message) if options[:plex]
      self.class.integration(:flash, level, message) if options[:flash]
    end

    def _logger
      self.class.logger
    end
  end

  module ClassMethods
    def logger
      @logger
    end

    def loggable(name, options={})
      @logger ||= Loggable.send(name)
      @options = (@options||{}).merge(options)
    end

    def integration(name, level, message)
      return unless @options[name] && @options[name] < Services::Base
      @options[name].send(level, message)
    end
  end
end
