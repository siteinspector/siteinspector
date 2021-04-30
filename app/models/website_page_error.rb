# frozen_string_literal: true

# == Schema Information
#
# Table name: website_page_errors
#
#  id              :bigint           not null, primary key
#  context         :text             not null
#  correction      :text             not null
#  error_type      :text             not null
#  status          :text             not null
#  text            :text             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  website_page_id :bigint           not null
#
# Indexes
#
#  index_website_page_errors_on_created_at                        (created_at) USING brin
#  index_website_page_errors_on_website_page_id                   (website_page_id)
#  website_page_errors_text_context_website_page_id_unique_index  (text,context,website_page_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (website_page_id => website_pages.id)
#
class WebsitePageError < ApplicationRecord
  TYPES = [
    GRAMMAR = 'grammar',
    DUPLICATE = 'duplicate',
    SPELLING = 'spelling',
    FALSE_POSITIVE = 'false_positive'
  ].freeze

  STATUSES = [
    PENDING = 'pending',
    RESOLVED = 'resolved'
  ].freeze

  belongs_to :website_page
  has_one :website, through: :website_page

  attribute :status, :string, default: 'pending'

  validates :error_type, inclusion: { in: TYPES }
  validates :status, inclusion: { in: STATUSES }

  scope :grammar, -> { where(error_type: GRAMMAR) }
  scope :spelling, -> { where(error_type: SPELLING) }
  scope :active, -> { where.not(error_type: FALSE_POSITIVE) }

  def resolved?
    status == RESOLVED
  end
end
