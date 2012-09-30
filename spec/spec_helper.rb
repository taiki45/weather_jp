# -*- coding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../", __FILE__)
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require 'rubygems'
require 'nokogiri'
require 'weather_jp'

def fixture_path
  File.expand_path('../fixture/', __FILE__)
end

def rss_one
  file = open(fixture_path + '/RSS.rss')
  yield file.read
  file.close
end
