# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebsitePage, type: :model do
  let(:website_page) { create(:website_page) }

  before do
    website_page.html = Rails.root.join('spec/fixtures/example.com.html').read
  end

  describe '.links' do
    specify do
      expect(website_page.links).to eq ['https://www.iana.org/domains/example', '/domains', '/domains/example.pdf']
    end
  end

  describe '.page_links' do
    specify do
      expect(website_page.page_links).to eq ['https://www.iana.org/domains/example', '/domains']
    end
  end

  describe '.external_links' do
    specify do
      expect(website_page.external_links).to eq ['https://www.iana.org/domains/example']
    end
  end

  describe '.internal_links' do
    specify do
      expect(website_page.internal_links).to eq ['/domains']
    end
  end

  describe '.resource_links' do
    specify do
      expect(website_page.resource_links).to eq ['/domains/example.pdf']
    end
  end

  describe '.images' do
    specify do
      expect(website_page.images).to eq ['/test']
    end
  end

  describe '.scripts' do
    specify do
      expect(website_page.scripts).to eq ['test.js']
    end
  end

  describe '.styles' do
    specify do
      expect(website_page.styles).to eq ['test.css']
    end
  end

  describe '.cleaned_text' do
    specify do
      expect(website_page.cleaned_text).to eq <<~TEXT.strip
        Example Domain Example Domain This domain is for use in illustrative examples in documents. You may use this domain in literature without prior coordination or asking for permission. More information... Relative PDF
      TEXT
    end
  end
end
