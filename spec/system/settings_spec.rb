# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Settings' do
  let(:current_user) { create(:user) }

  before do
    visit settings_path(user_id: current_user.id)
  end

  describe 'user form' do
    it 'updates email' do
      within '.account-form' do
        fill_in 'email', with: 'test@test.test'

        click_on 'Update'
      end

      expect(current_user.reload.email).to eq 'test@test.test'
    end
  end

  describe 'users list' do
    it 'adds new user' do
      click_on 'Add User'

      within '.ivu-modal-body' do
        fill_in 'email', with: 'test@test.test'
        fill_in 'password', with: '12345678'

        click_on 'Submit'
      end

      expect(page).to have_content 'test@test.test'
    end
  end

  describe 'sign out' do
    it 'redirects to sign in page' do
      click_on 'Sign Out'

      expect(page).to have_current_path new_user_session_path, ignore_query: true
    end
  end
end
