require "forwardable"

class Kyoko
  class JobQueue
    extend Forwardable

    attr_reader :job

    def_delegator :@queue, :deq, :dequeue
    def_delegators :@queue, :clear, :empty?, :size

    def initialize(&block)
      raise ArgumentError, "#{self.class.name} requires a block" unless block_given?

      @queue = Queue.new
      @job   = block
    end

    def enqueue(*args)
      @queue.enq(args)
    end
    alias :<< :enqueue
  end
end
