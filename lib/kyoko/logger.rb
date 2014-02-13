require "forwardable"
require "logger"
require "singleton"

class Kyoko
  class Logger
    include Singleton
    extend  Forwardable

    def_delegators :@logger, :debug, :info, :warn, :error, :fatal

    def initialize
      logdev = ENV["LOG_DEV"] || STDOUT
      level  = ::Logger.const_get(ENV["LOG_LEVEL"] ? ENV["LOG_LEVEL"].upcase : :INFO)

      @logger = ::Logger.new(logdev)
      @logger.level = level
      @logger.formatter = proc do |severity, datetime, progname, msg|
        # %w(debug info warn error fatal).map(&:length).max
        "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity.ljust(5)} - #{msg}\n"
      end
    end
  end
end
