# frozen_string_literal: true

# == Schema Information
#
# Table name: custom_rules
#
#  id         :bigint           not null, primary key
#  condition  :text             not null
#  paths      :jsonb            not null
#  pattern    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  website_id :bigint           not null
#
# Indexes
#
#  index_custom_rules_on_website_id  (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (website_id => websites.id)
#
class CustomRule < ApplicationRecord
  CONDITIONS = [
    CONTAIN = 'contain',
    NOT_CONTAIN = 'not_contain'
  ].freeze

  belongs_to :website

  has_many :results, class_name: 'CustomRuleResult', dependent: :destroy
  has_many :active_results, -> { active }, class_name: 'CustomRuleResult',
                                           dependent: :destroy,
                                           inverse_of: :custom_rule

  validates :condition, inclusion: { in: CONDITIONS }
end
