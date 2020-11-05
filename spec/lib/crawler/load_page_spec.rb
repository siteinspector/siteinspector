# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Crawler::LoadPage do
  describe '#call' do
    let!(:website) { create(:website) }

    before do
      stub_request(:get, website.url).to_return(status: 200, body: '<html>', headers: {})
    end

    context 'with existing page' do
      let!(:existing_page) do
        create(:website_page, website: website, url: website.url, sha1: Digest::SHA1.hexdigest('<html>'))
      end

      it 'returns existing page' do
        expect(described_class.call(website, website.url).page.id).to eq existing_page.id
      end
    end
  end
end
