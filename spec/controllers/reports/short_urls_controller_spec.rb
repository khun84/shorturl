require 'rails_helper'

RSpec.describe Reports::ShortUrlsController, type: :controller do
  describe '#show' do
    let(:current_user) { build_stubbed(:user) }
    let(:short_url) { create(:short_url) }
    let(:url_hash) { short_url.url_hash }
    before do
      allow(controller).to receive(:current_user).and_return(current_user)
    end
    subject { get :show, params: { id: url_hash } }

    it 'should return status 200' do
      subject
      expect(response.status).to eq 200
    end

    context 'when short url not found' do
      let(:url_hash) { 'not-exists' }
      it 'should return 404' do
        subject
        expect(response.status).to eq 404
      end
    end
  end
end