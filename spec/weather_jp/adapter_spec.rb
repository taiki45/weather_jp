require 'spec_helper'

RSpec.describe WeatherJp::Adapter do
  describe '.get' do
    include Fixturable

    context 'when found' do
      set_fixture 'tokyo.xml'
      subject { described_class.get('tokyo') }
      it { is_expected.to be_kind_of(WeatherJp::Weather) }
    end

    context 'when not found' do
      set_fixture 'not_found.xml'
      subject { described_class.get('no_found_city') }
      it { is_expected.to be_nil }
    end
  end

  describe WeatherJp::Adapter::Reader do
    describe '.read' do
      before { stub_request(:get, 'http://example.com') }
      subject { described_class.read('http://example.com') }
      it { is_expected.to eq('') }
    end
  end
end
