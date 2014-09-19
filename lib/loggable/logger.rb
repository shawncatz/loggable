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
      _log(:warn, message, options)
    end

    def error(message, options={})
      _log(:error, message, options)
    end

    def error!(message, options={})
      _log(:error, message, options)
      raise message
    end

    private

    def _log(level, message, options)
      _logger.send(level, message)
      self.class.integration(:faye, level, message) if options[:faye] # send to faye integration, if faye: true
      self.class.integration(:plex, level, message) if options[:plex] # send to plex integration, if plex: true
      self.class.integration(:flash, level, message) if options[:flash] # send to flash (faye) integration, if flash: true
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
      # options[name] < Services::Base ensures that option is subclass of Services::Base
      return unless @options[name] && @options[name] < Services::Base
      @options[name].send(level, message)
    end
  end
end
