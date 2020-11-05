# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboard' do
  let!(:website) { create(:website) }
  let(:current_user) { create(:user) }

  before do
    visit dashboard_path(user_id: current_user.id)
  end

  describe 'website scanning' do
    it 'starts website scanning' do
      click_on 'Scan'

      expect(page).to have_content 'Scanning'
      expect(page).to have_content 'Stop'

      click_on 'Info'

      within '.ivu-drawer-body' do
        expect(page).to have_content 'created'
      end
    end
  end

  describe 'website settings' do
    it 'updates website settings' do
      click_on 'Settings'

      within '.ivu-drawer-body' do
        fill_in 'start_path', with: '/test'

        click_on 'Submit'
      end

      expect(website.reload.preferences.start_path).to eq '/test'
    end
  end

  describe 'website form' do
    before do
      stub_request(:get, %r{\Ahttp://(?:www\.)?example.com/}).to_return(status: 200)
    end

    it 'creates a new website' do
      click_on 'Add Website', class: 'ivu-btn-long'

      within '.ivu-modal-body' do
        fill_in 'URL or domain', with: 'example.com'

        click_on 'Submit'
      end

      page.driver.wait_for_network_idle

      expect(page).to have_content 'example.com'
    end
  end
end
