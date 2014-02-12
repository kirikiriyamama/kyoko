require "shellwords"
require "systemu"
require "kyoko/logger"

class Kyoko
  class Job
    class Say < Kyoko::Job
      def self.perform(text)
        Kyoko::Logger.instance.info("Say! - #{text}")

        command = "say -v kyoko #{Shellwords.escape(text)}"
        status, stdout, stderr = systemu(command)
        unless status.exitstatus.zero?
          Kyoko::Logger.instance.error(status.inspect)
          Kyoko::Logger.instance.debug(stderr.chomp)
        end
      end
    end
  end
end
