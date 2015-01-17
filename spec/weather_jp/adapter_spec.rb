require 'spec_helper'

RSpec.describe WeatherJp::Adapter::Reader do
  describe '.read' do
    before { stub_request(:get, 'http://example.com') }
    subject { described_class.read('http://example.com') }
    it { is_expected.to eq('') }
  end
end

