require 'rails_helper'

RSpec.describe ShortUrlClickStats do
  describe '#results' do
    let!(:user_1) { create(:user) }
    let!(:user_2) { create(:user) }
    let!(:user_1_url_1) { create(:url, user: user_1) }
    let!(:user_1_short_url_1) { create(:short_url, url: user_1_url_1) }
    let!(:short_url_1_click_1) { create(:url_click, url_hash: user_1_short_url_1.url_hash, original_url_id: user_1_url_1.id, created_at: Time.new(2021, 10, 3)) }
    let!(:short_url_1_click_2) { create(:url_click, url_hash: user_1_short_url_1.url_hash, original_url_id: user_1_url_1.id, created_at: Time.new(2021, 10, 3)) }

    let!(:user_1_url_2) { create(:url, user: user_1) }
    let!(:user_1_short_url_2) { create(:short_url, url: user_1_url_2) }
    let!(:short_url_2_click_1) { create(:url_click, url_hash: user_1_short_url_2.url_hash, original_url_id: user_1_url_2.id, created_at: Time.new(2021, 10, 4)) }
    let!(:short_url_2_click_2) { create(:url_click, url_hash: user_1_short_url_2.url_hash, original_url_id: user_1_url_2.id, created_at: Time.new(2021, 10, 10)) }

    let!(:user_1_url_3) { create(:url, user: user_1) }
    let!(:user_1_short_url_3) { create(:short_url, url: user_1_url_3) }

    let!(:user_2_url_4) { create(:url, user: user_2) }
    let!(:user_2_short_url_4) { create(:short_url, url: user_2_url_4) }
    let!(:short_url_4_click_1) { create(:url_click, url_hash: user_2_short_url_4.url_hash, original_url_id: user_2_url_4.id, created_at: Time.new(2021, 10, 4)) }

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
                                                 "url_hash" => user_1_short_url_1.url_hash,
                                                 "click_count" => 2
                                               },
                                               {
                                                 "id" => nil,
                                                 "title" => user_1_url_2.title,
                                                 "original_url" => user_1_url_2.original_url,
                                                 "url_hash" => user_1_short_url_2.url_hash,
                                                 "click_count" => 1
                                               },
                                               {
                                                 "id" => nil,
                                                 "title" => user_1_url_3.title,
                                                 "original_url" => user_1_url_3.original_url,
                                                 "url_hash" => user_1_short_url_3.url_hash,
                                                 "click_count" => 0
                                               },
                                               {
                                                 "id" => nil,
                                                 "title" => user_2_url_4.title,
                                                 "original_url" => user_2_url_4.original_url,
                                                 "url_hash" => user_2_short_url_4.url_hash,
                                                 "click_count" => 1
                                               }
                                             ])
    end

    context 'when do not include zero click count' do
      let(:params) { super().merge(include_zero: false) }
      it 'should return non zero count for each long url' do
        expect(subject.as_json).to match_array([
                                                 {
                                                   "id" => nil,
                                                   "title" => user_1_url_1.title,
                                                   "original_url" => user_1_url_1.original_url,
                                                   "url_hash" => user_1_short_url_1.url_hash,
                                                   "click_count" => 2
                                                 },
                                                 {
                                                   "id" => nil,
                                                   "title" => user_1_url_2.title,
                                                   "original_url" => user_1_url_2.original_url,
                                                   "url_hash" => user_1_short_url_2.url_hash,
                                                   "click_count" => 1
                                                 },
                                                 {
                                                   "id" => nil,
                                                   "title" => user_2_url_4.title,
                                                   "original_url" => user_2_url_4.original_url,
                                                   "url_hash" => user_2_short_url_4.url_hash,
                                                   "click_count" => 1
                                                 }
                                               ])
      end
    end

    context 'when filter by user id' do
      let(:params) { super().merge(user_id: user_1.id) }
      it 'should return count for selected user id' do
        expect(subject.as_json).to match_array([
                                                 {
                                                   "id" => nil,
                                                   "title" => user_1_url_1.title,
                                                   "original_url" => user_1_url_1.original_url,
                                                   "url_hash" => user_1_short_url_1.url_hash,
                                                   "click_count" => 2
                                                 },
                                                 {
                                                   "id" => nil,
                                                   "title" => user_1_url_2.title,
                                                   "original_url" => user_1_url_2.original_url,
                                                   "url_hash" => user_1_short_url_2.url_hash,
                                                   "click_count" => 1
                                                 },
                                                 {
                                                   "id" => nil,
                                                   "title" => user_1_url_3.title,
                                                   "original_url" => user_1_url_3.original_url,
                                                   "url_hash" => user_1_short_url_3.url_hash,
                                                   "click_count" => 0
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
                                                   "url_hash" => user_1_short_url_1.url_hash,
                                                   "click_count" => 2
                                                 },
                                                 {
                                                   "id" => nil,
                                                   "title" => user_1_url_2.title,
                                                   "original_url" => user_1_url_2.original_url,
                                                   "url_hash" => user_1_short_url_2.url_hash,
                                                   "click_count" => 0
                                                 },
                                                 {
                                                   "id" => nil,
                                                   "title" => user_1_url_3.title,
                                                   "original_url" => user_1_url_3.original_url,
                                                   "url_hash" => user_1_short_url_3.url_hash,
                                                   "click_count" => 0
                                                 },
                                                 {
                                                   "id" => nil,
                                                   "title" => user_2_url_4.title,
                                                   "original_url" => user_2_url_4.original_url,
                                                   "url_hash" => user_2_short_url_4.url_hash,
                                                   "click_count" => 0
                                                 }
                                               ])
      end
    end
  end
end
