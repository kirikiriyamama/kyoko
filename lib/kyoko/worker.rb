require "forwardable"
require "kyoko/logger"

class Kyoko
  class Worker
    extend Forwardable

    def_delegator :@thread, :terminate

    def initialize(job_queue)
      @job_queue = job_queue
      @thread    = nil
    end

    def start
      @thread = Thread.new do
        loop do
          begin
            args = @job_queue.dequeue
            @job_queue.job.call(*args)
          rescue => e
            Kyoko::Logger.instance.error(e.inspect)
            Kyoko::Logger.instance.debug(e.backtrace.join("\n"))
          end
        end
      end
    end
  end
end
