require "logger"
require "forwardable"

class Kyoko
  class Logger
    extend Forwardable

    def_delegators :@logger, :debug, :info, :warn, :error, :fatal

    def initialize(logdev: STDOUT, level: ::Logger::INFO)
      @logger = ::Logger.new(logdev)
      @logger.level = level
      @logger.formatter = proc do |severity, datetime, progname, msg|
        "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity}: #{msg}\n"
      end
    end
  end
end
