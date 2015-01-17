module WeatherJp
  module RequestParser
    class << self
      RequestMatcher = /
        ((?<city>.*)の
        (?<day>今日|きょう|今|いま|明日|あした|明後日|あさって|３日後|４日後|3日後|4日後)
        の(天気|てんき).*) |
        ((?<day>今日|きょう|今|いま|明日|あした|明後日|あさって|３日後|４日後|3日後|4日後)の
        (?<city>.*)の(天気|てんき))
      /ux

      def parser(str)
        if str =~ RequestMatcher
          data = Regexp.last_match
          day = data[:day]
          case day
          when /今日|きょう|今|いま/u
            day = 'today'
          when /明日|あした/u
            day = 'tomorrow'
          when /明後日|あさって/u
            day = 'day_after_tomorrow'
          when /3日後|３日後/u
            day = 3
          when /4日後|４日後/u
            day = 4
          else
            raise WeatherJpError, "Can't parse given String"
          end

          {day: day, city: data[:city]}
        else
          nil
        end
      end
    end
  end
end
