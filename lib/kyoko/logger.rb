require "forwardable"
require "logger"
require "singleton"

class Kyoko
  class Logger
    include Singleton
    extend  Forwardable

    def_delegators :@logger, :debug, :info, :warn, :error, :fatal

    def initialize
      @logger = ::Logger.new(STDOUT)
      @logger.level = ::Logger::INFO
      @logger.formatter = proc do |severity, datetime, progname, msg|
        "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity}: #{msg}\n"
      end
    end
  end
end
