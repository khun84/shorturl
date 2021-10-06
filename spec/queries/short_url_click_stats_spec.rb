require 'rails_helper'

RSpec.describe ShortUrlClickStats do
  describe '#results' do
    let!(:user_1) { create(:user) }
    let!(:user_2) { create(:user) }
    let!(:user_1_url_1) { create(:url, user: user_1) }
    let!(:url_1_click_1) { create(:url_click, url_hash: 'url-hash-1', original_url_id: user_1_url_1.id, created_at: Time.new(2021, 10, 3)) }
    let!(:url_1_click_2) { create(:url_click, url_hash: 'url-hash-1', original_url_id: user_1_url_1.id, created_at: Time.new(2021, 10, 3)) }

    let!(:user_1_url_2) { create(:url, user: user_1) }
    let!(:url_2_click_1) { create(:url_click, url_hash: 'url-hash-2', original_url_id: user_1_url_2.id, created_at: Time.new(2021, 10, 4)) }
    let!(:url_2_click_2) { create(:url_click, url_hash: 'url-hash-2', original_url_id: user_1_url_2.id, created_at: Time.new(2021, 10, 10)) }

    let!(:user_1_url_3) { create(:url, user: user_1) }

    let!(:user_2_url_4) { create(:url, user: user_2) }
    let!(:url_4_click_1) { create(:url_click, url_hash: 'url-hash-4', original_url_id: user_2_url_4.id, created_at: Time.new(2021, 10, 4)) }

    let(:params) do
      {
        since: Time.new(2021, 10, 2),
        until: Time.new(2021, 10, 5)
      }
    end

    subject { described_class.new(params).results }

    it 'should return count for each long url' do
      expect(subject.as_json).to match_array([
                                               {
                                                 "id" => nil,
                                                 "title" => user_1_url_1.title,
                                                 "original_url" => user_1_url_1.original_url,
                                                 "url_hash" => "url-hash-1",
                                                 "click_count" => 2
                                               },
                                               {
                                                 "id" => nil,
                                                 "title" => user_1_url_2.title,
                                                 "original_url" => user_1_url_2.original_url,
                                                 "url_hash" => "url-hash-2",
                                                 "click_count" => 1
                                               },
                                               {
                                                 "id" => nil,
                                                 "title" => user_2_url_4.title,
                                                 "original_url" => user_2_url_4.original_url,
                                                 "url_hash" => "url-hash-4",
                                                 "click_count" => 1
                                               }
                                             ])
    end

    context 'when filter by user id' do
      let(:params) { super().merge(user_id: user_1.id) }
      it 'should return count for selected user id' do
        expect(subject.as_json).to match_array([
                                                 {
                                                   "id" => nil,
                                                   "title" => user_1_url_1.title,
                                                   "original_url" => user_1_url_1.original_url,
                                                   "url_hash" => "url-hash-1",
                                                   "click_count" => 2
                                                 },
                                                 {
                                                   "id" => nil,
                                                   "title" => user_1_url_2.title,
                                                   "original_url" => user_1_url_2.original_url,
                                                   "url_hash" => "url-hash-2",
                                                   "click_count" => 1
                                                 }
                                               ])
      end
    end

    context 'when filter by date range' do
      let(:params) { super().merge(until: Time.new(2021, 10, 3, 16)) }
      it 'should return count within selected date range' do
        expect(subject.as_json).to match_array([
                                                 {
                                                   "id" => nil,
                                                   "title" => user_1_url_1.title,
                                                   "original_url" => user_1_url_1.original_url,
                                                   "url_hash" => "url-hash-1",
                                                   "click_count" => 2
                                                 }
                                               ])
      end
    end
  end
end
