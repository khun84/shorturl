require 'rails_helper'

describe RedirectionController, type: :controller do
  describe '#show' do
    let(:params) { {url_hash: 'url-hash'} }
    let(:short_url) { build_stubbed(:short_url, url: build_stubbed(:url, original_url: 'http://example.com')) }
    before do
      allow(ShortUrl).to receive(:find_by_url_hash).and_return(short_url)
    end
    subject { get :show, params: params }
    it 'should redirect to original url' do
      subject
      expect(response).to redirect_to short_url.original_url
      expect(response.status).to eq 301
    end

    context 'when short url not exists' do
      let(:short_url) { nil }
      it 'should render error page' do
        subject
        expect(response.status).to eq 404
      end
    end
  end
end
