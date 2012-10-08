# -*- coding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../", __FILE__)
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require 'nokogiri'
require 'weather_jp'

module WeatherJp::Wrapper
  class << self
    def get_area_code(city_name)
      ["JAXX0085", 'tokyo']
    end

    def get_rss(area_code)
      get_dummy_rss
    end
  end
end

def fixture_path
  File.expand_path('../fixture/', __FILE__)
end

def get_dummy_rss
  rss = ''
  open(fixture_path + '/RSS.rss') do |file|
    rss = RSS::Parser.parse(file.read)
  end
  rss
end

def get_ny_rss
  rss = ''
  open fixture_path + '/ny.rss' do |file|
    rss = RSS::Parser.parse file.read
  end
  rss
end
