# -*- encoding: utf-8 -*-
require File.expand_path('../lib/weather_jp/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Taiki ONO"]
  gem.email         = ["taiks.4559@gmail.com"]
  gem.description   = "Fetch Japan weather info as Ruby object easily."
  gem.summary       = "Japan weather info API wrapper."
  gem.homepage      = "http://taiki45.github.com/weather_jp"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "weather_jp"
  gem.require_paths = ["lib"]
  gem.version       = WeatherJp::VERSION

  gem.add_dependency "nokogiri", "~>1.5.5"
  gem.add_dependency "rake", ">= 0.9.2"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rspec-core"
end
