require "kyoko/job_queue"
require "kyoko/logger"
require "kyoko/twitter"
require "kyoko/worker"

class Kyoko
  def initialize(config)
    @job_queue = Kyoko::JobQueue.new
    @worker    = Kyoko::Worker.new(@job_queue).start
    @streamer  = Kyoko::Twitter::Streamer.new(
      oauth:     config["twitter"]["oauth"],
      filters:   config["twitter"]["filters"],
      job_queue: @job_queue
    )
  end

  def run
    @streamer.start
  end
end
