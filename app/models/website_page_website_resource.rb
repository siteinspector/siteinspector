# frozen_string_literal: true

# == Schema Information
#
# Table name: website_page_website_resources
#
#  id                  :bigint           not null, primary key
#  is_resolved         :boolean          default(FALSE), not null
#  website_page_id     :bigint           not null
#  website_resource_id :bigint
#
# Indexes
#
#  index_website_page_website_resources_on_website_resource_id  (website_resource_id)
#  website_page_website_resources_index                         (website_page_id,website_resource_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (website_page_id => website_pages.id)
#  fk_rails_...  (website_resource_id => website_resources.id)
#
class WebsitePageWebsiteResource < ApplicationRecord
  belongs_to :website_page
  belongs_to :website_resource

  has_one :broken_link, -> { broken }, class_name: 'WebsiteResource',
                                       foreign_key: :id,
                                       primary_key: :website_resource_id,
                                       dependent: :destroy,
                                       inverse_of: 'website_page_website_resources'
end
