# frozen_string_literal: true

# == Schema Information
#
# Table name: custom_rule_results
#
#  id              :bigint           not null, primary key
#  deleted_at      :datetime
#  message         :text             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  custom_rule_id  :bigint           not null
#  website_page_id :bigint           not null
#
# Indexes
#
#  custom_rule_results_text_context_website_page_id_unique_index  (custom_rule_id,website_page_id,message) UNIQUE
#  index_custom_rule_results_on_website_page_id                   (website_page_id)
#
# Foreign Keys
#
#  fk_rails_...  (custom_rule_id => custom_rules.id)
#  fk_rails_...  (website_page_id => website_pages.id)
#
class CustomRuleResult < ApplicationRecord
  belongs_to :custom_rule
  belongs_to :website_page
  has_one :website, through: :website_page

  scope :active, -> { joins(:website_page).where(website_pages: { deleted_at: nil }, deleted_at: nil) }
end
