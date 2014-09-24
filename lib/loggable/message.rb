class Loggable::Message
  attr_reader :title, :message, :level, :facility

  def initialize(options={})
    @title = options[:title]
    @message = options[:message]
    @level = options[:level]
    @facility = options[:facility]
  end
end
