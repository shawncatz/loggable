class Loggable::Logger
  def initialize(name, options)
    @logger = Loggable.send(name.to_sym)
    defaults = Loggable.plugins.inject({}) {|h, e| h[e.to_sym] = false; h}
    @options = defaults.merge(options)
  end

  def debug(title, message=nil, options={})
    _log(:debug, title, message, options)
  end

  def info(title, message=nil, options={})
    _log(:info, title, message, options)
  end

  def warn(title, message=nil, options={})
    _log(:warn, title, message, options)
  end

  def error(title, message=nil, options={})
    _log(:error, title, message, options)
  end

  def error!(title, message=nil, options={})
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
    else
      @logger.send(level, title)
    end
    Loggable.plugins.each do |int|
      _plugin(int.to_sym, level, title, message) if options[int.to_sym] # send to integration, if option true
    end
  end

  def _logger
    @logger
  end

  def _plugin(name, level, title, message=nil)
    # options[name] < Services::Base ensures that option is subclass of Services::Base
    return unless @options[name] && @options[name] < Loggable::Base
    @options[name].send(:loggable, level, title, message)
  end
end
