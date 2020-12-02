# frozen_string_literal: true

module Siteinspector
  module CheckResource
    RESOURCE_UPDATE_DURATION = 1.day

    module_function

    # @param page [WebsitePage]
    # @param link [String]
    # @param type [String] Crawler::RESOURCE_TYPES
    # @return [WebsiteResource, nil]
    def call(page, link, type: nil)
      url = UrlUtils.join_url(page.url, link)

      return if Siteinspector::SkipUrls.include?(url)

      resource = page.website.resources.find_or_initialize_by(url: url)

      return resource if resource.excluded?

      if resource.new_record? || resource.updated_at < RESOURCE_UPDATE_DURATION.ago
        load_or_update_resource!(resource, url, type)
      end

      return resource if resource.status == Crawler::OK
      return resource if WebsitePageWebsiteResource.exists?(website_page: page, website_resource: resource)

      WebsitePageWebsiteResource.create!(website_page: page, website_resource: resource)

      resource
    rescue Addressable::URI::InvalidURIError
      save_invalid_resource!(page, link, Crawler::LINK)
    rescue ActiveRecord::RecordNotUnique
      retry
    end

    # @param resource [WebsiteResource]
    # @param url [String]
    # @param type [String] Crawler::RESOURCE_TYPES
    # @return [WebsiteResource]
    def load_or_update_resource!(resource, url, type)
      resp = Crawler::Conn.call(type == Crawler::LINK ? :get : :head, url)

      resource.update!(effective_url: resp.effective_url,
                       status: Crawler.fetch_status(resp),
                       resource_type: type || Crawler.fetch_resource_type(resp))

      resource
    end

    # @param page [WebsitePage]
    # @param link [String]
    # @param type [String] Crawler::RESOURCE_TYPES
    # @return [WebsiteResource]
    def save_invalid_resource!(page, link, type)
      resource = page.website_resources.find_by(url: link)

      return resource if resource

      resource = page.website.resources.find_by(url: link)

      if resource
        page.website_resources << resource

        return resource
      end

      resource = WebsiteResource.new(website: page.website,
                                     url: link,
                                     effective_url: link,
                                     status: :invalid,
                                     resource_type: type)

      page.website_resources << resource

      resource
    rescue ActiveRecord::RecordNotUnique
      retry
    end
  end
end
