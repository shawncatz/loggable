module Loggable::Integration
  extend ActiveSupport::Concern
  included do
    def _logger
      self.class.logger
    end
    def debug(title, message=nil, options={})
      _logger.debug(title, message, options)
    end
    def info(title, message=nil, options={})
      _logger.info(title, message, options)
    end
    def warn(title, message=nil, options={})
      _logger.warn(title, message, options)
    end
    def error(title, message=nil, options={})
      _logger.error(title, message, options)
    end
    def error!(title, message=nil, options={})
      _logger.error(title, message, options)
      raise message ? "#{title} - #{message}" : title
    end
  end

  module ClassMethods
    def debug(title, message=nil, options={})
      logger.info(title, message, options)
    end

    def info(title, message=nil, options={})
      logger.info(title, message, options)
    end

    def warn(title, message=nil, options={})
      logger.info(title, message, options)
    end

    def error(title, message=nil, options={})
      logger.info(title, message, options)
    end

    def error!(title, message=nil, options={})
      logger.info(title, message, options)
      raise message
    end

    def loggable(name, options={})
      # @logger ||= Loggable.send(name)
      # @options = (@options||{}).merge(options)
      define_singleton_method(:logger) do
        @logger ||= Loggable::Logger.new name, options.merge(facility: self.name)
      end
    end
  end
end
