# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebsitePages::Spellcheck do
  describe '#call' do
    let(:website_page) { create(:website_page) }

    context 'with spelling errors' do
      before do
        website_page.html = '<p>Did you recieve the leter?</p>'
      end

      specify do
        mistakes = described_class.call(website_page)

        expect(mistakes.first.text).to eq 'recieve'
        expect(mistakes.last.text).to eq 'leter'
      end
    end
  end
end
