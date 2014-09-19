class Loggable::Base
  class << self
    def debug(title, message)
      message(:debug, title, message)
    end

    def info(title, message)
      message(:info, title, message)
    end

    def warn(title, message)
      message(:warn, title, message)
    end

    def error(title, message)
      message(:error, title, message)
    end

    def loggable(level, title, message=nil)
      message(level, title, message)
    end

    private

    def simpletime
      t = Time.now
      "%02d/%02d %02d:%02d" % [t.month, t.day, t.hour, t.min]
    end
  end
end
