require "forwardable"

class Kyoko
  class JobQueue
    extend Forwardable

    def_delegator :@queue, :deq, :dequeue
    def_delegators :@queue, :clear, :empty?, :size

    def initialize
      @queue = Queue.new
    end

    def enqueue(klass, *args)
      @queue.enq([klass, *args])
    end
    alias :<< :enqueue
  end
end
