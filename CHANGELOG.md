# CHANGELOG
## 2.0.0
- `WeatherJp::City` now available. You can get latitude/longitude of the city.
- `WeatherJp::Weather#current`. The current weather is a little bit differrnt from day weather forecast.
  - have: `temperature`, `wind_speed`, `wind_text`
  - not have: `precip`, `high`, `low`.
- `WeatherJp::Weather#each` now contains the `DayWeather` object which represents current weather status. If you do not want current weather status, use `each_without_current` or `except_current` method.
- Remove `customize_to_s` method. This feature will be re-added as configurable procedure.
- Remove option from `WeatherJp.get`. If you use these option, use `WeatherJp::Weather#for`.
- Some deprecations for method names.

## 1.0.4
Bug fixes

- Rain probability and tempratures are returned as Fixnum. [Sho Hashimoto - @shokai]
- Can handle tempratures below zero. [Sho Hashimoto - @shokai]

## 1.0.0
- Add parse method to WeatherJp
- see READEME for more description
