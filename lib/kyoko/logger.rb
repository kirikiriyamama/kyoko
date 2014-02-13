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
        "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity} - #{msg}\n"
      end
    end
  end
end
