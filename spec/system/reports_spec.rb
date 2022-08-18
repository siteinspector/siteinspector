# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboard' do
  let!(:website) { create(:website) }
  let(:current_user) { create(:user) }

  describe 'error report' do
    let!(:website_page) { create(:website_page, website: website) }
    let!(:broken_link) { create(:website_resource, website: website, status: Crawler::NOT_FOUND) }
    let!(:website_page_error) { create(:website_page_error, website_page: website_page) }
    let!(:custom_rule) { create(:custom_rule, website: website) }
    let!(:custom_rule_result) { create(:custom_rule_result, custom_rule: custom_rule, website_page: website_page) }
    let!(:website_page_website_resource) do
      create(:website_page_website_resource, website_page: website_page, website_resource: broken_link)
    end

    before do
      visit reports_path(user_id: current_user.id)
    end

    it 'shows all valid errors' do
      expect(page).to have_content 'Spelling errors: 1'
      expect(page).to have_content 'Grammatical errors: 0'
      expect(page).to have_content 'Broken links: 1'
      expect(page).to have_content 'Custom checks: 1'

      expect(page).to have_link broken_link.effective_url
      expect(page).to have_content website_page_error.context
      expect(page).to have_content custom_rule_result.message
    end

    describe 'page errors' do
      it 'marks error as false positive' do
        click_on '', class: 'more-button'

        within '.ivu-poptip-body' do
          find('.ivu-cell-title', text: 'False positive in context').click
        end

        expect(page).not_to have_content website_page_error.context
      end

      it 'marks error as resolved' do
        within "#page_error_#{website_page_error.id}" do
          find('.ivu-checkbox').click
        end

        expect(website_page_error.reload.status).to eq WebsitePageError::RESOLVED
      end
    end

    describe 'broken links' do
      it 'marks link as resolved' do
        within "#resource_#{broken_link.id}" do
          find('.ivu-checkbox').click
        end

        expect(website_page_website_resource.reload.is_resolved).to be true
      end

      it 'excludes link' do
        within "#resource_#{broken_link.id}" do
          find('.ivu-tag').click
        end

        within '.ivu-poptip-footer' do
          click_on 'OK'
        end

        expect(broken_link.reload.status).to eq 'excluded'
      end
    end

    describe 'shared report' do
      it 'opens shared report' do
        click_on 'Share Report'

        within '.ivu-modal-body' do
          visit find('.ivu-input').value
        end

        expect(page).to have_current_path shared_path, ignore_query: true

        expect(page).to have_content 'Spelling errors: 1'
        expect(page).to have_content 'Grammatical errors: 0'

        expect(page).to have_content website_page_error.context
      end
    end
  end
end
