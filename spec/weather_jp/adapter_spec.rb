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
      subject { described_class.read('http://example.com') }

      context 'with valid condition' do
        before { stub_request(:get, 'http://example.com') }
        it { is_expected.to eq('') }
      end

      context 'with server down' do
        before { stub_request(:get, 'http://example.com').to_return(status: 500) }
        specify do
          expect { subject }.to raise_error(WeatherJp::ServiceUnavailable, /500/)
        end
      end

      context 'with server maintenance' do
        before { stub_request(:get, 'http://example.com').to_return(status: 503) }
        specify do
          expect { subject }.to raise_error(WeatherJp::ServiceUnavailable, /503/)
        end
      end
    end
  end
end
