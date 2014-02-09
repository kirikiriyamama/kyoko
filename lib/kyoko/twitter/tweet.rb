class Kyoko
  module Twitter
    class Tweet
      def initialize(tweet)
        # Twitter::Tweet#text returns frozen text
        @text     = tweet.text.chars.join
        # exclude html tags
        @source   = tweet.source.gsub(/<("[^"]*"|'[^']*'|[^'">])*>/, "")
        # in case of Twitter::Tweet#entities? is false, if call a method, then warning will be occured
        @urls     = tweet.entities? ? tweet.urls     : []
        @hashtags = tweet.entities? ? tweet.hashtags : []
      end

      def strip
        _text = @text

        # shindanmaker
        @urls.each do |url|
          return nil if url.expanded_url.to_s.index("shindanmaker")
        end

        # foursquare
        return nil if _text.index(/^I'm at /)
        _text.slice!(/ \(@ .*\)/)

        # path
        _text.slice!(/ (\(at .*\) )?\[pic\] —.*/)
        _text.slice!(/♫ .+ by .+/) if @source == "Path 2.0"

        # ustream
        _text.slice!(/ \(.*live at.*\)/)

        # unofficial retweet
        _text.slice!(/ ?(RT|QT).*/)

        # hashtags
        @hashtags.each { |hashtag| _text.sub!(/[#＃]#{hashtag.text}/, "") }

        # user_mentions
        _text.gsub!(/(\.?|(?<![\w&_\/]))@([\w_]{1,15})/, "")

        # urls
        _text.gsub!(/(https?|ftp):\/\/[\w_,.:;&=+*%$#!?@()~\'\/-]+/, "")

        # newlines
        _text.gsub!("\n", " ")

        # leading and trailing spaces
        _text.gsub!(/^[\s　]+|[\s　]+$/, "")

        _text.empty? ? nil : _text
      end
    end
  end
end
