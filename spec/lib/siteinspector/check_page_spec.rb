# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Siteinspector::CheckPage do
  describe '#call' do
    let!(:crawl_session) { create(:crawl_session) }

    context 'with ok status' do
      subject(:resource) { described_class.call(crawl_session, link: '/test', origin_page_id: -1) }

      before do
        stub_request(:get, "#{crawl_session.website.url}/test").to_return(status: 200, headers: {}, body: '<html>')
      end

      specify do
        expect(resource.status).to eq Crawler::OK
      end
    end

    context 'with not_found status' do
      let(:origin_page) { create(:website_page, website: crawl_session.website) }

      before do
        stub_request(:get, "#{crawl_session.website.url}/test").to_return(status: 404, headers: {}, body: '<html>')
      end

      specify do
        described_class.call(crawl_session, link: '/test', origin_page_id: origin_page.id)

        expect(origin_page.website_resources.first.status).to eq Crawler::NOT_FOUND
      end
    end
  end
end
