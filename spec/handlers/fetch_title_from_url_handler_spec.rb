require 'rails_helper'
require 'open-uri'

RSpec.describe FetchTitleFromUrlHandler do
  describe '#call!' do
    let(:url) { 'https://www.beenverified.com/faq/' }
    let(:expected_title) { 'Frequently Asked Questions | BeenVerified' }
    let(:html_content) do
      <<-EOS
        <html>
          <head>
            <title>#{expected_title}</title>
          </head>
          <body>Some Content</body>
        </html>
      EOS
    end
    let(:handler) { described_class.new(url) }

    subject { handler.call! }

    context 'when request is successful' do
      before do
        allow(handler).to receive_message_chain(:open, :read).and_return(html_content)
      end

      it 'returns the title' do
        expect(subject).to eq(expected_title)
      end
    end

    context 'when url is invalid' do
      let(:url) { 'invalid-url' }

      before do
        allow(handler).to receive_message_chain(:open, :read).and_raise(Errno::ENOENT)
      end

      it 'raises an InvalidUrlError' do
        expect { subject }.to raise_error(InvalidUrlError, "Invalid URL: #{url}")
      end
    end
  end
end
