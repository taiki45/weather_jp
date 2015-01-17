require 'spec_helper'

RSpec.describe WeatherJp do
  include Fixturable
  set_fixture 'tokyo.xml'

  describe '.get' do
    subject { described_class.get(:tokyo) }
    it { is_expected.to be_kind_of(WeatherJp::Weather) }
  end
end
