require "forwardable"
require "kyoko/logger"

class Kyoko
  class JobQueue
    extend Forwardable

    attr_reader :job

    def_delegators :@queue, :clear, :empty?, :size

    def initialize(&block)
      raise ArgumentError, "#{self.class.name} requires a block" unless block_given?

      @queue = Queue.new
      @job   = block
    end

    def enqueue(*args)
      @queue.enq(args)
      Kyoko::Logger.instance.debug("Enqueued: queue has #{@queue.size} job(s)")
    end
    alias :<< :enqueue

    def dequeue
      @queue.deq
      Kyoko::Logger.instance.debug("Dequeued: queue has #{@queue.size} job(s)")
    end
  end
end
