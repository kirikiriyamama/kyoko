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
      # measures when dequeue immediately after enqueue
      Kyoko::Logger.instance.debug("Enqueued: queue has #{@queue.size + 1} job(s)")
      @queue.enq([klass, *args])
      self
    end
    alias :<< :enqueue

    def dequeue
      ret = @queue.deq
      Kyoko::Logger.instance.debug("Dequeued: queue has #{@queue.size} job(s)")
      ret
    end
  end
end
