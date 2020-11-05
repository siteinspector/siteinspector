# frozen_string_literal: true

# == Schema Information
#
# Table name: website_pages
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  lang       :text             not null
#  sha1       :text             not null
#  status     :text             not null
#  title      :text             not null
#  url        :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  website_id :bigint           not null
#
# Indexes
#
#  index_website_pages_on_created_at                   (created_at) USING brin
#  index_website_pages_on_website_id_and_url           (website_id,url) UNIQUE WHERE (deleted_at IS NULL)
#  index_website_pages_on_website_id_and_url_and_sha1  (website_id,url,sha1) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (website_id => websites.id)
#
class WebsitePage < ApplicationRecord
  STATUSES = Crawler::STATUSES

  attr_accessor :html

  belongs_to :website

  has_many :page_errors, dependent: :destroy, autosave: true, class_name: 'WebsitePageError'
  has_many :active_page_errors, -> { active }, dependent: :destroy,
                                               class_name: 'WebsitePageError',
                                               inverse_of: 'website_page'
  has_many :website_page_website_resources, class_name: 'WebsitePageWebsiteResource',
                                            dependent: :destroy, inverse_of: 'website_page'

  has_many :broken_website_page_website_resource_links, -> { joins(:broken_link) },
           class_name: 'WebsitePageWebsiteResource',
           dependent: :destroy,
           inverse_of: 'website_page'
  has_many :website_resources, through: :website_page_website_resources, inverse_of: 'website_pages'
  has_many :broken_links, -> { broken.links }, class_name: 'WebsiteResource',
                                               through: :website_page_website_resources,
                                               source: :website_resource

  has_many :custom_rule_results, dependent: :destroy, inverse_of: 'website_page'
  has_many :active_custom_rule_results, -> { active }, class_name: 'CustomRuleResult',
                                                       dependent: :destroy,
                                                       inverse_of: 'website_page'

  before_validation :set_lang, :set_title

  validates :status, inclusion: { in: STATUSES }
  validates :lang, :url, :sha1, presence: true

  scope :active, -> { where(deleted_at: nil) }
  scope :with_errors, -> { where(WebsitePages::WITH_ERRORS_SQL) }

  def raw_text
    @raw_text ||= WebsitePages::Parser.parse_text(doc, "\n")
  end

  def cleaned_text
    @cleaned_text ||= raw_text.squish
  end

  def links
    @links ||= WebsitePages::Parser.parse_links(doc)
  end

  def page_links
    @page_links ||= links - resource_links
  end

  def resource_links
    @resource_links ||= links.select { |l| UrlUtils.file?(l) }
  end

  def internal_links
    @internal_links ||= page_links.select { |link| UrlUtils.internal?(link, domain) }
  end

  def domain
    @domain ||= UrlUtils.extract_domain(url)
  end

  def external_links
    @external_links ||= page_links - internal_links
  end

  def styles
    @styles ||= WebsitePages::Parser.parse_styles(doc)
  end

  def scripts
    @scripts ||= WebsitePages::Parser.parse_scripts(doc)
  end

  def images
    @images ||= WebsitePages::Parser.parse_images(doc)
  end

  def path
    @path ||= UrlUtils.extract_path(url)
  end

  def doc
    @doc ||=
      if html.blank?
        Nokogiri::XML(html)
      else
        doc = Nokogiri::HTML(html)
        doc = WebsitePages::Parser.clear_doc(doc)

        exclude_path = website.preferences.exclude_xpath

        doc.search(exclude_path).each(&:remove) if exclude_path.present?

        doc
      end
  end

  private

  def set_title
    self.title ||= WebsitePages::Parser.parse_title(doc)
  end

  def set_lang
    self.lang ||= CLD.detect_language(cleaned_text)[:code]
  end
end
