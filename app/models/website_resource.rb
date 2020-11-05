# frozen_string_literal: true

# == Schema Information
#
# Table name: website_resources
#
#  id            :bigint           not null, primary key
#  effective_url :text             not null
#  resource_type :text             not null
#  status        :text             not null
#  url           :text             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  website_id    :bigint           not null
#
# Indexes
#
#  index_website_resources_on_website_id_and_status  (website_id,status)
#  index_website_resources_on_website_id_and_url     (website_id,url) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (website_id => websites.id)
#
class WebsiteResource < ApplicationRecord
  TYPES = Crawler::RESOURCE_TYPES
  STATUSES = Crawler::STATUSES + %w[excluded]

  belongs_to :website

  has_many :website_page_website_resources, class_name: 'WebsitePageWebsiteResource',
                                            dependent: :destroy,
                                            inverse_of: 'website_resource'
  has_many :website_pages, through: :website_page_website_resources, inverse_of: 'website_resources'
  has_many :active_website_pages, -> { active }, through: :website_page_website_resources,
                                                 class_name: 'WebsitePage',
                                                 source: 'website_page',
                                                 inverse_of: 'website_resources'

  validates :resource_type, inclusion: { in: TYPES }
  validates :status, inclusion: { in: STATUSES }
  validates :url, :effective_url, presence: true

  scope :broken, -> { where(status: %w[not_found invalid unavailable unknown]) }
  scope :links, -> { where(resource_type: :link) }
end
