require 'rails_helper'

RSpec.describe Locateable do
  let(:dummy_class) do
    klass = Class.new do
      include Locateable
    end
    klass
  end

  describe '.lookup_location' do
    let(:location_result) do
      OpenStruct.new(
        address: 'address',
        latitude: 'latitude',
        longitude: 'longitude',
        state: 'state',
        province: 'province',
        state_code: 'state_code',
        province_code: 'province_code',
        country: 'country',
        country_code: 'country_code',
      )
    end
    before do
      allow(Geocoder).to receive(:search).and_return([location_result])
    end
    subject { dummy_class.lookup_location('8.8.8.8') }

    it 'should return location detail' do
      expect(subject).to eq({
                              "data" => {
                                "address" => "address",
                                "latitude" => "latitude",
                                "longitude" => "longitude",
                                "state" => "state",
                                "province" => "province",
                                "state_code" => "state_code",
                                "province_code" => "province_code",
                                "country" => "country",
                                "country_code" => "country_code",
                                "ip" => "8.8.8.8"
                              },
                              "provider" => :ipinfo_io
                            })
      expect(Geocoder).to have_received(:search).with('8.8.8.8', ip_lookup: :ipinfo_io)
    end
  end
end
