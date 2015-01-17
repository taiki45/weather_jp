module WeatherJp
  module RequestParser
    class Request < Struct.new(:city, :day)
    end

    class << self
      dates_regexp = "今日|きょう|明日|あした|明後日|あさって|今|いま|3日後|３日後|4日後|４日後"
      RequestMatcher = /
        (
          (?<city>.*)の(?<day>#{dates_regexp})の(天気|てんき).*
        )|(
          (?<day>#{dates_regexp})の(?<city>.*)の(天気|てんき)
        )
      /ux

      def parser(str)
        if str =~ RequestMatcher
          data = Regexp.last_match
          day = data[:day]
          case day
          when /今日|きょう/u
            day = :today
          when /明日|あした/u
            day = :tomorrow
          when /明後日|あさって/u
            day = :day_after_tomorrow
          when /3日後|３日後/
            day = 3
          when /4日後|４日後/
            day = 4
          when /今|いま/
            day = :current
          end

          Request.new(data[:city], day)
        else
          nil
        end
      end
    end
  end
end
