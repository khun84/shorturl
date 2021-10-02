require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'validation' do
    context 'original url uniqueness' do
      subject { create(:url) }
      it do
        subject
        should validate_uniqueness_of(:original_url)
      end
    end

    context 'original url presence' do
      subject { build(:url) }
      it { should validate_presence_of(:title) }
    end

    context 'title presence' do
      subject { build(:url) }
      it { should validate_presence_of(:title) }
    end

    context 'validate url format' do
      let(:original_url) { 'https://example.com' }
      let(:url) { build(:url, original_url: original_url) }

      it 'should pass the validation' do
        expect(url.valid?).to eq(true)
      end

      context 'invalid url format' do
        let(:original_url) { 'htp://foo' }
        it 'should not pass the validation' do
          expect(url.valid?).to eq(false)
        end
      end
    end
  end
end
