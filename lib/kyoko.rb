require "shellwords"
require "systemu"
require "kyoko/job_queue"
require "kyoko/logger"
require "kyoko/twitter"
require "kyoko/worker"

class Kyoko
  def initialize(config)
    job = lambda do |text|
      Kyoko::Logger.instance.info("Say! - #{text}")

      command = "say -v kyoko #{Shellwords.escape(text)}"
      status, stdout, stderr = systemu(command)
      unless status.exitstatus.zero?
        Kyoko::Logger.instance.error(status.inspect)
        Kyoko::Logger.instance.debug(stderr.chomp)
      end
    end

    @job_queue = Kyoko::JobQueue.new(&job)
    @worker    = Kyoko::Worker.new(@job_queue).start
    @streamer  = Kyoko::Twitter::Streamer.new(
      oauth:     config["oauth"],
      filters:   config["filters"],
      job_queue: @job_queue
    )
  end

  def run
    @streamer.start
  end
end
