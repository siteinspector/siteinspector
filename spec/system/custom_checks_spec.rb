# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboard' do
  let!(:website) { create(:website) }
  let(:current_user) { create(:user) }

  describe 'rule form' do
    before do
      create(:website)

      visit custom_checks_path(user_id: current_user.id)
    end

    it 'creates a new rule' do
      click_on 'Add Rule', class: 'ivu-btn-long'

      within '.ivu-modal-body' do
        find('.ivu-select').click
        find('.ivu-select-item', text: website.domain).click

        fill_in 'pattern', with: 'hello world'

        click_on 'Submit'
      end

      expect(page).to have_content 'hello world'
    end
  end

  describe 'rules list' do
    before do
      create(:custom_rule, website: website, pattern: 'test test')

      visit custom_checks_path(user_id: current_user.id)
    end

    it 'removes rule' do
      find('.ion-md-trash').click

      within '.ivu-modal-body' do
        click_on 'OK'
      end

      expect(page).not_to have_content 'test test'
    end
  end
end
