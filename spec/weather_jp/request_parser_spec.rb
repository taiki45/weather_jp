require 'spec_helper'

describe WeatherJp::RequestParser do
  describe '.parse' do
    it "should parse japanese string" do
      {
        "東京の今日の天気" => {day: "today", city: "東京"},
        "今日の東京の天気" => {day: "today", city: "東京"},
        "東京のいまの天気" => {day: "today", city: "東京"},
        "いまの東京の天気" => {day: "today", city: "東京"},
        "東京の今の天気" => {day: "today", city: "東京"},
        "今の東京の天気" => {day: "today", city: "東京"},
        "東京の明日の天気" => {day: "tomorrow", city: "東京"},
        "東京の明後日の天気" => {day: "day_after_tomorrow", city: "東京"},
        "東京の3日後の天気" => {day: 3, city: "東京"},
        "東京の３日後の天気" => {day: 3, city: "東京"},
        "東京の4日後の天気" => {day: 4, city: "東京"},
        "東京の４日後の天気" => {day: 4, city: "東京"},
        "東京の今日の天気教えて〜" => {day: "today", city: "東京"},
        "あきるの市の今日の天気" => {day: "today", city: "あきるの市"},
        "あきるの市の今日の天気教えなさい" => {day: "today", city: "あきるの市"},
        "今日のあきるの市の天気" => {day: "today", city: "あきるの市"}
      }.each do |test, expect|
        WeatherJp::RequestParser.parser(test).should == expect
      end
    end
  end
end
