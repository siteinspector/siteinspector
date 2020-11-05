# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebsitePages::CheckCustomRules do
  describe '#call' do
    let(:website_page) { create(:website_page) }

    context 'with string pattern' do
      before do
        create(:custom_rule, pattern: 'lorem', condition: CustomRule::NOT_CONTAIN, website: website_page.website)

        website_page.html = '<p>Lorem ipsum</p>'
      end

      specify do
        expect(described_class.call(website_page).size).to eq 1
      end
    end

    context 'with regex pattern' do
      before do
        create(:custom_rule, pattern: '/lorem/i',
                             condition: CustomRule::NOT_CONTAIN,
                             website: website_page.website)

        website_page.html = '<p>Lorem ipsum</p>'
      end

      specify do
        expect(described_class.call(website_page).size).to eq 1
      end
    end
  end
end
