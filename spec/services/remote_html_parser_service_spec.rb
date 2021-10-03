require 'rails_helper'

RSpec.describe RemoteHtmlParserService do
  describe '.run' do
    let(:params) do
      {
        url: 'https://www.google.com',
        queries: ['head > title'],
      }
    end

    let(:vcr_scenario) { :google_html }

    subject do
      VCR.use_cassette(vcr_scenario) do
        described_class.run(params)
      end
    end

    it 'should success' do
      expect(subject.success?).to eq true
      expect(subject.result).to eq({"head > title"=>["Google"]})
    end

    context 'when content type is not html' do
      let(:vcr_scenario) { :not_html }
      it 'should fail with error message' do
        expect(subject.success?).to eq false
        expect(subject.errors.message).to eq({"url"=>"Response is not in html format"})
      end
    end

    context 'when sanitise option is false' do
      let(:vcr_scenario) { :escapable_html }
      let(:params) { super().merge(opts: { sanitize: false }) }
      it 'should escape html character in output' do
        expect(subject.success?).to eq true
        expect(subject.result).to eq({"head > title"=>["<foo>Google</foo>"]})
      end
    end

    context 'when not return as inner html' do
      let(:params) { super().merge(opts: { as: :somethingelse }) }
      it 'should return output as html element' do
        expect(subject.success?).to eq true
        expect(subject.result['head > title']).to all(be_kind_of(Nokogiri::XML::Element))
      end
    end
  end
end
