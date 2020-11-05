# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Siteinspector::CheckResource do
  describe '#call' do
    let!(:website_page) { create(:website_page) }

    context 'with ok status' do
      subject(:resource) { described_class.call(website_page, '/test.pdf') }

      before do
        stub_request(:head, "#{website_page.url}test.pdf").to_return(status: 200)
      end

      specify do
        expect(resource.status).to eq Crawler::OK
      end
    end

    context 'with not_found status' do
      subject(:resource) { described_class.call(website_page, 'http://example.com/test', type: Crawler::LINK) }

      before do
        stub_request(:get, 'http://example.com/test').to_return(status: 404)
      end

      specify do
        expect(resource.status).to eq Crawler::NOT_FOUND
      end
    end
  end
end
