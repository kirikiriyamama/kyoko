require "kyoko/logger"
require "kyoko/job/say"

class Kyoko
  class Job
    def self.perform(*args)
      Kyoko::Logger.instance.error("#{self}.#{__method__} is necessary to override")
    end
  end
end
