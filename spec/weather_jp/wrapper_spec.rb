# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'Wrapper' do
  describe '.set_weathers' do
    it 'should make vaild data' do
      expect = [{:day=>'今日', :forecast=>'晴のち雨', :max_temp=>29, :min_temp=>24, :rain=>80},
        {:day=>'明日', :forecast=>'雨のち晴', :max_temp=>30, :min_temp=>22, :rain=>60},
        {:day=>'火曜日', :forecast=>'曇時々晴', :max_temp=>27, :min_temp=>22, :rain=>30},
        {:day=>'水曜日', :forecast=>'曇時々雨', :max_temp=>25, :min_temp=>20, :rain=>50},
        {:day=>'木曜日', :forecast=>'曇り', :max_temp=>28, :min_temp=>20, :rain=>40},
        {:day=>'金曜日', :forecast=>'曇り', :max_temp=>-3, :min_temp=>-20, :rain=>40}
      ]
      dummy_data = ['今日: 晴のち雨. 最低: 24&#176;C. 最高: 29&#176;C. 降水確率: 80',
        '明日: 雨のち晴. 最低: 22&#176;C. 最高: 30&#176;C. 降水確率: 60',
        '火曜日: 曇時々晴. 最低: 22&#176;C. 最高: 27&#176;C. 降水確率: 30',
        '水曜日: 曇時々雨. 最低: 20&#176;C. 最高: 25&#176;C. 降水確率: 50',
        '木曜日: 曇り. 最低: 20&#176;C. 最高: 28&#176;C. 降水確率: 40',
        '金曜日: 曇り. 最低: -20&#176;C. 最高: -3&#176;C. 降水確率: 40'
      ]
      expect(WeatherJp::Wrapper.set_weathers(dummy_data)).to eq(expect)
    end

    it 'should parse non-japan weather info' do
      #expect = [{:day=>'現在の天気', :forecast=>'(5時51分 現在)晴れ', :max_temp=>nil, :min_temp=>nil, :rain=>nil}]
      expect = [{:day=>'現在', :forecast=>'(5時51分 現在)晴れ', :max_temp=>nil, :min_temp=>nil, :rain=>nil}]
      dummy = ['現在の天気: (5時51分 現在)晴れ. 7&#176;C (体感気温 8). 湿度: 89']
      expect(WeatherJp::Wrapper.set_weathers(dummy)).to eq(expect)
    end
  end

  describe '.parse_rss' do
    it 'should parse rss data' do
      expect = ['今日: 晴のち雨. 最低: 24&#176;C. 最高: 29&#176;C. 降水確率: 80',
        '明日: 雨のち晴. 最低: 22&#176;C. 最高: 30&#176;C. 降水確率: 60',
        '火曜日: 曇時々晴. 最低: 22&#176;C. 最高: 27&#176;C. 降水確率: 30',
        '水曜日: 曇時々雨. 最低: 20&#176;C. 最高: 25&#176;C. 降水確率: 50',
        '木曜日: 曇り. 最低: 20&#176;C. 最高: 28&#176;C. 降水確率: 40'
      ]
      expect(WeatherJp::Wrapper.parse_rss(get_dummy_rss)).to eq(expect)
    end

    it 'should parse non-japan data' do
      expect = ['現在の天気: (5時51分 現在)晴れ. 7&#176;C (体感気温 8). 湿度: 89']
      expect(WeatherJp::Wrapper.parse_rss(get_ny_rss)).to eq(expect)
    end

    describe '.remove_html_tag' do
      it 'should remove html tags' do
        str = %q(<html>a<a href="dummy">b</a><span>c</sapan></html>)
        expect(WeatherJp::Wrapper.remove_html_tag(str)).to eq(%(""a""b""""c""""))
      end
    end
  end
end

