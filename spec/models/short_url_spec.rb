require 'rails_helper'

RSpec.describe ShortUrl, type: :model do

  describe "ShortUrl" do

    let(:short_url) { create(:short_url, full_url: "https://www.beenverified.com/faq/") }

    it "finds a short_url with the short_code" do
      expect(ShortUrl.find_by_short_code(short_url.short_code)).to eq short_url
    end

  end

  describe "a new short_url instance" do

    let(:short_url) { described_class.new }

    it "isn't valid without a full_url" do
      expect(short_url).to_not be_valid
      expect(short_url.errors[:full_url]).to be_include("can't be blank")
    end

    it "has an invalid url" do
      short_url.full_url = 'javascript:alert("Hello World");'
      expect(short_url).to_not be_valid
      expect(short_url.errors[:full_url]).to be_include("is not a valid url")
    end

    it "doesn't have a short_code" do
      expect(short_url.short_code).to be_nil
    end

  end

  describe "existing short_url instance" do

    let(:short_url) { create(:short_url, full_url: "https://www.beenverified.com/faq/") }

    it "has a short code" do
      # Just validate the short_code class bc specs run in random order
      # and we don't actually know what the string is going to be
      expect(short_url.short_code).to be_a(String)
    end

    it "has a click_counter" do
      expect(short_url.click_count).to eq 0
    end

    it "fetches the title" do
      short_url.update_title!
      expect(short_url.title).to eq("Frequently Asked Questions | BeenVerified")
    end

    context "with a higher id" do
      let(:id) { nil }
      let(:expected_short_code) { nil }
      let(:short_url) { create(:short_url, id: id, full_url: "https://www.beenverified.com/faq/") }

      shared_examples_for 'it has the expected short code' do
        it "has the expected short_code" do
          expect(short_url.short_code).to eq(expected_short_code)
        end
      end

      context 'when id is 1001' do
        let(:id) { 1001 }
        let(:expected_short_code) { 'g9' }

        it_behaves_like 'it has the expected short code'
      end

      context 'when id is 50' do
        let(:id) { 50 }
        let(:expected_short_code) { 'O' }

        it_behaves_like 'it has the expected short code'
      end
    end
  end
end
