class Loggable::Logger
  def initialize(name, options)
    @logger = Loggable.send(name.to_sym)
    enabled = Loggable.plugins.inject({}) {|h, e| h[e.to_sym] = false; h}
    @options = enabled.merge(options)
    @defaults = Loggable.config['defaults']
  end

  def debug(title, message=nil, send_to={})
    _log(:debug, title, message, send_to)
  end

  def info(title, message=nil, send_to={})
    _log(:info, title, message, send_to)
  end

  def warn(title, message=nil, send_to={})
    _log(:warn, title, message, send_to)
  end

  def error(title, message=nil, send_to={})
    _log(:error, title, message, send_to)
  end

  def error!(title, message=nil, send_to={})
    _log(:error, title, message, send_to)
    raise message
  end

  private

  def _log(level, title, message, send_to={})
    if message.is_a?(Hash)
      send_to = message
      message = nil
    end

    if message
      @logger.send(level, "#{title} - #{message}")
    else
      @logger.send(level, title)
    end

    o = @defaults.merge(send_to)
    Loggable.plugins.each do |int|
      _plugin(int.to_sym, level, title, message) if o[int.to_sym] # send to integration, if option true
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
