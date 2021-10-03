require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  let(:user) { build_stubbed(:user) }
  before do
    allow(controller).to receive(:user_signed_in?).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'show' do
    context 'when url not found' do
      it 'should redirect to url index page' do
        get :show, params: {id: -1}
        expect(response).to redirect_to urls_path
      end
    end
  end

  describe 'new' do
    it 'should success' do
      get :new
      expect(response.status).to eq 200
    end
  end

  describe 'create' do
    let(:params) do
      {
        url: {
          original_url: 'http://example.com',
          title: 'title'
        }
      }.deep_stringify_keys

    end
    let(:url) { build_stubbed(:url) }
    let(:mutation) { Urls::Create }
    let(:outcome) { double(success?: true, result: url) }
    before do
      allow(mutation).to receive(:run).and_return(outcome)
    end
    it 'should create url and redirect to url detail page' do
      post :create, params: params
      expect(mutation).to have_received(:run).with(params['url'].merge(user: user))
      expect(response).to redirect_to(url_path(url))
    end

    context 'when failed' do
      let(:outcome) { double(inputs: params, success?: false, errors: {err: 'err-msg'}) }
      it 'should redirect to new url form page' do
        post :create, params: params
        expect(response).to redirect_to(new_url_path)
      end
    end
  end
end
