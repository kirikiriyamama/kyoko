require "forwardable"
require "kyoko/logger"

class Kyoko
  class JobQueue
    extend Forwardable

    def_delegators :@queue, :clear, :empty?, :size

    def initialize
      @queue = Queue.new
    end

    def enqueue(klass, *args)
      @queue.enq([klass, *args])
      Kyoko::Logger.instance.debug("Enqueued: queue has #{@queue.size} job(s)")
    end
    alias :<< :enqueue

    def dequeue
      @queue.deq
      Kyoko::Logger.instance.debug("Dequeued: queue has #{@queue.size} job(s)")
    end
  end
end
