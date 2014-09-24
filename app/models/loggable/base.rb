class Loggable::Base
  class << self

    def loggable(loggable)
      message(loggable)
    end

    private

    def message(loggable)
      raise "must override Loggable::Base#message"
    end

    def simpletime
      t = Time.now
      "%02d/%02d %02d:%02d" % [t.month, t.day, t.hour, t.min]
    end
  end
end
