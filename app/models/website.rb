# frozen_string_literal: true

# == Schema Information
#
# Table name: websites
#
#  id          :bigint           not null, primary key
#  domain      :citext           not null
#  preferences :jsonb            not null
#  slug        :citext           not null
#  status      :text             not null
#  url         :citext           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_websites_on_domain  (domain) UNIQUE
#  index_websites_on_slug    (slug) UNIQUE
#
class Website < ApplicationRecord
  STATUSES = [
    ENABLED = 'enabled',
    DISABLED = 'disabled'
  ].freeze

  serialize :preferences, Websites::PreferencesSerializer

  attribute :status, :string, default: ENABLED

  has_many :pages, class_name: 'WebsitePage', inverse_of: 'website', dependent: :destroy
  has_many :active_pages, -> { active }, class_name: 'WebsitePage', inverse_of: 'website', dependent: :destroy
  has_many :pages_with_errors, -> { active.with_errors }, class_name: 'WebsitePage',
                                                          inverse_of: 'website',
                                                          dependent: :destroy
  has_many :resources, class_name: 'WebsiteResource', inverse_of: 'website', dependent: :destroy
  has_many :custom_rules, inverse_of: 'website', dependent: :destroy
  has_many :custom_rule_results, through: :custom_rules,
                                 source: :results,
                                 inverse_of: 'website',
                                 dependent: :destroy
  has_many :page_errors, through: :pages
  has_many :active_page_errors, -> { active }, through: :active_pages, class_name: 'WebsitePageError'
  has_many :crawl_sessions, dependent: :destroy

  validates :status, inclusion: { in: STATUSES }
  validates :domain, :url, :status, presence: true

  before_validation :set_slug

  scope :enabled, -> { where(status: :enabled) }

  def enabled?
    status == ENABLED
  end

  private

  def set_slug
    self.slug = domain.tr('.', '-') if domain_changed?
  end
end
