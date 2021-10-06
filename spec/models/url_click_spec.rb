require 'rails_helper'

RSpec.describe UrlClick, type: :model do
  describe '.track' do
    let(:data) do
      {
        url_hash: 'url-hash-1',
        short_url_id: 1,
        original_url_id: 2,
        event_time: Time.new(2021, 10, 3),
      }
    end
    before do
      allow(described_class).to receive(:lookup_location).and_return({"data" => {"address" => "address"}, "provider" => :ipinfo_io})
    end
    subject { described_class.track(data) }
    it 'should create a track record' do
      expect { subject }.to change(described_class, :count).by(1)
      expect(described_class.last).to have_attributes(
                                        url_hash: 'url-hash-1',
                                        short_url_id: 1,
                                        original_url_id: 2,
                                        created_at: Time.new(2021, 10, 3),
                                        updated_at: Time.new(2021, 10, 3),
                                        location_details: {
                                          "data" => {
                                            "address" => "address"
                                          },
                                          "provider" => 'ipinfo_io'
                                        }
                                      )
    end

    context 'when location lookup is nil' do
      before do
        allow(described_class).to receive(:lookup_location).and_return(nil)
      end

      it 'should save empty hash' do
        expect { subject }.to change(described_class, :count).by(1)
        expect(described_class.last).to have_attributes(
                                          location_details: {}
                                        )
      end
    end

    context 'when event time is not given' do
      let(:current_time) { Time.new(2021, 10, 4) }
      let(:data) { super().except(:event_time) }
      it 'should default to current time' do
        Timecop.freeze(current_time) do
          subject
          expect(described_class.last).to have_attributes(
                                            created_at: Time.new(2021, 10, 4),
                                            updated_at: Time.new(2021, 10, 4)
                                          )
        end
      end
    end
  end
end
