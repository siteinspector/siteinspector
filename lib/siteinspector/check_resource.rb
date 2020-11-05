# frozen_string_literal: true

module Siteinspector
  module CheckResource
    module_function

    # @param page [WebsitePage]
    # @param link [String]
    # @param type [String] Crawler::RESOURCE_TYPES
    # @return [WebsiteResource, nil]
    def call(page, link, type: nil)
      url = UrlUtils.join_url(page.url, link)

      return if Siteinspector::SkipUrls.include?(url)

      resource = page.website.resources.find_by(url: url)

      resp = Crawler::Conn.call(type == Crawler::LINK ? :get : :head, url)

      resource ||= WebsiteResource.new(website: page.website,
                                       url: url,
                                       resource_type: type || Crawler.fetch_resource_type(resp))

      resource.update!(effective_url: resp.effective_url, status: Crawler.fetch_status(resp))

      return resource if resource.status == Crawler::OK
      return resource if WebsitePageWebsiteResource.exists?(website_page: page, website_resource: resource)

      WebsitePageWebsiteResource.create!(website_page: page, website_resource: resource)

      resource
    rescue Addressable::URI::InvalidURIError
      save_invalid_resource!(page, link, Crawler::LINK)
    rescue ActiveRecord::RecordNotUnique
      retry
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
