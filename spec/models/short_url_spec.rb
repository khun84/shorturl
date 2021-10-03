require 'rails_helper'

RSpec.describe ShortUrl, type: :model do
  describe 'validations' do
    context '#url_hash presence' do
      subject { build(:short_url) }
      it { should validate_presence_of(:url_hash) }
    end

    context '#url_hash length' do
      subject { build(:short_url) }
      it { should validate_length_of(:url_hash).is_at_most(described_class::MAX_LENGTH) }
      it { should validate_length_of(:url_hash).is_at_least(described_class::MIN_LENGTH) }
    end

    context '#url_hash uniqueness' do
      subject { create(:short_url) }
      it { should validate_uniqueness_of(:url_hash) }
    end
  end

  describe '.generate_url_hash' do
    let(:length) { nil }
    subject { described_class.generate_url_hash(length: length) }

    context 'when length is given' do
      let(:length) { 7 }
      it 'should hash url in given length' do
        expect(subject.length).to eq 7
      end
    end

    context 'uniqueness' do
      let(:length) { 7 }
      let(:iteration_count) { 10 }
      subject do
        url_hashes = []
        iteration_count.times do
          url_hashes << described_class.generate_url_hash(length: length)
        end
        url_hashes.uniq
      end

      it 'should generate different hash in different calls' do
        expect(subject.length).to eq iteration_count
      end
    end
  end
end
