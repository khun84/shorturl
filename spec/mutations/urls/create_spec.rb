require 'rails_helper'

RSpec.describe Urls::Create do
  let(:user) { build_stubbed(:user) }

  describe 'validation' do
    let(:inputs) do
      {
        user: user,
        original_url: 'https://example.com',
        title: 'example'
      }
    end

    subject { described_class.validate(inputs) }

    context 'when url model is not valid' do
      before do
        allow_any_instance_of(Url).to receive(:valid?).and_return(false)
        allow_any_instance_of(Url).to receive(:errors).and_return(
          ActiveModel::Errors.new(Url.new).tap { |e| e.add(:title, 'dummy error')}
        )
      end
      it 'should fail with error message' do
        expect(subject.success?).to eq false
        expect(subject.errors.message).to eq({"url"=>"Title dummy error"})
      end
    end

    context 'when short url model is not valid' do
      before do
        allow_any_instance_of(ShortUrl).to receive(:valid?).and_return(false)
        allow_any_instance_of(ShortUrl).to receive(:errors).and_return(
          ActiveModel::Errors.new(ShortUrl.new).tap { |e| e.add(:url_hash, 'dummy error')}
        )
      end
      it 'should fail with error message' do
        expect(subject.success?).to eq false
        expect(subject.errors.message).to eq({"url"=>"Short urls url hash dummy error"})
      end
    end
  end

  describe 'execute' do
    let(:inputs) do
      {
        user: user,
        original_url: 'https://example.com',
        title: 'example'
      }
    end
    subject { described_class.run(inputs) }

    it 'should create url successfully' do
      expect(subject.success?).to eq true
      url = subject.result.reload
      expect(url).to have_attributes(
                       original_url: inputs[:original_url],
                       title: inputs[:title],
                       user_id: user.id
                     )
    end

    it 'should create one associated short url' do
      expect(subject.result.short_urls.count).to eq 1
    end
  end
end