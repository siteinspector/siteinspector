# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Siteinspector do
  describe '#call' do
    let!(:crawl_session) { create(:crawl_session) }

    before do
      stub_request(:get, "https://#{crawl_session.website.domain}/")
        .to_return(status: 200, body: Rails.root.join('spec/fixtures/example.com.html').read)
    end

    specify do
      described_class.call(crawl_session)

      expect(crawl_session.reload.status).to eq CrawlSession::STARTED
      expect(crawl_session.website.active_pages.count).to eq 1
      expect(crawl_session.website.active_pages.count).to eq 1

      expect(CheckPageWorker.jobs.size).to eq 1
      expect(CheckResourceWorker.jobs.size).to eq 5
    end
  end
end
