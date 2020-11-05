# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Setup' do
  describe 'first run' do
    before { visit root_path }

    describe 'sign up with email and password' do
      context 'with valid credentials' do
        before do
          stub_request(:get, %r{\Ahttp://(?:www\.)?example.com/}).to_return(status: 200)
        end

        it 'redirects to /dashboard' do
          fill_in 'email', with: 'test@test.test'
          fill_in 'password', with: '12345678'

          click_on "Let's go!"

          fill_in 'URL or domain', with: 'example.com'

          click_on 'Scan website'

          page.driver.wait_for_network_idle

          click_on 'Skip this step'

          expect(page).to have_content 'Websites'
          expect(page).to have_content 'example.com'
          expect(page).to have_content 'Spelling errors'

          expect(page).to have_current_path dashboard_path, ignore_query: true
        end
      end
    end
  end

  describe 'with existing user' do
    before do
      create(:user)

      visit setup_path
    end

    it 'redirects to /sign_in' do
      expect(page).to have_current_path new_user_session_path, ignore_query: true
    end
  end
end
