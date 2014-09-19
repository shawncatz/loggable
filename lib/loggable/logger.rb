class Loggable::Logger
  def initialize(name, options)
    @logger = Loggable.send(name.to_sym)
    @options = {plex: false, faye: false, flash: false}.merge(options)
  end

  def debug(title, message, options={})
    _log(:debug, title, message, options)
  end

  def info(title, message, options={})
    _log(:info, title, message, options)
  end

  def warn(title, message, options={})
    _log(:warn, title, message, options)
  end

  def error(title, message, options={})
    _log(:error, title, message, options)
  end

  def error!(title, message, options={})
    _log(:error, title, message, options)
    raise message
  end

  private

  def _log(level, title, message, options={})
    if message.is_a?(Hash)
      options = message
      message = nil
    end
    if message
      @logger.send(level, "#{title} - #{message}")
      _integration(:faye, level, "#{title} - #{message}") if options[:faye] # send to faye integration, if faye: true
    else
      @logger.send(level, title)
      _integration(:faye, level, title) if options[:faye] # send to faye integration, if faye: true
    end
    _integration(:plex, level, title, message) if options[:plex] # send to plex integration, if plex: true
    _integration(:flash, level, title, message) if options[:flash] # send to flash (faye) integration, if flash: true
  end

  def _logger
    @logger
  end

  def _integration(name, level, title, message=nil)
    # options[name] < Services::Base ensures that option is subclass of Services::Base
    return unless @options[name] && @options[name] < Services::Base
    @options[name].send(:loggable, level, title, message)
  end
end
