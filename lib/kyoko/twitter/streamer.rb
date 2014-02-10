require "twitter"
require "kyoko/logger"

class Kyoko
  module Twitter
    class Streamer
      def initialize(oauth:, filters:, job_queue:)
        @streamer = ::Twitter::Streaming::Client.new do |config|
          config.consumer_key        = oauth["consumer_key"]
          config.consumer_secret     = oauth["consumer_secret"]
          config.access_token        = oauth["access_token"]
          config.access_token_secret = oauth["access_token_secret"]
        end
        @filters   = filters
        @job_queue = job_queue
      end

      def start
        @streamer.filter(track: @filters.join(","), &self.method(:hundle))
      end

      private

      def hundle(object)
        case object
        when ::Twitter::DirectMessage
        when ::Twitter::Streaming::DeletedTweet
        when ::Twitter::Streaming::Event
        when ::Twitter::Streaming::FriendList
        when ::Twitter::Streaming::StallWarning
          Kyoko::Logger.instance.warn(object)
        when ::Twitter::Tweet
          hundle_tweet(object)
        else
          Kyoko::Logger.instance.warn(object)
        end
      end

      def hundle_tweet(tweet)
        text = Kyoko::Twitter::Tweet.new(tweet).strip
        @job_queue.enqueue(text) unless text.nil?
      end
    end
  end
end
