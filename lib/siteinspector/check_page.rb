# frozen_string_literal: true

module Siteinspector
  module CheckPage
    module_function

    # @param crawl_session [CrawlSession]
    # @param link [String]
    # @param origin_page_id [Integer]
    # @return [WebsitePage]
    def call(crawl_session, link:, origin_page_id:)
      result = Crawler::LoadPage.call(crawl_session.website, link)

      page = result.page

      return page if result.file?

      if result.external?
        Siteinspector::CheckResource.call(page, page.url)

        return page
      end

      process_page(crawl_session, page)

      save_not_found_page_link(page, origin_page_id: origin_page_id, link: link) if page.status == Crawler::NOT_FOUND

      page
    rescue Addressable::URI::InvalidURIError
      Siteinspector::CheckResource.save_invalid_resource!(WebsitePage.find(origin_page_id), link, Crawler::LINK)

      page
    end

    # @param crawl_session [CrawlSession]
    # @param page [WebsitePage]
    # @return [WebsitePage]
    def process_page(crawl_session, page)
      WebsitePages::Spellcheck.call(page) if perform_spellchecking?(page)
      WebsitePages::CheckCustomRules.call(page)

      if page.website.preferences.check_links
        Siteinspector.enqueue_resources(page: page, links: page.external_links, type: Crawler::LINK)
        Siteinspector.enqueue_resources(page: page, links: page.resource_links)
      end

      if page.website.preferences.check_images
        Siteinspector.enqueue_resources(page: page, links: page.images, type: Crawler::IMAGE)
      end

      if page.website.preferences.check_scripts
        Siteinspector.enqueue_resources(page: page, links: page.scripts, type: Crawler::SCRIPT)
        Siteinspector.enqueue_resources(page: page, links: page.styles, type: Crawler::STYLE)
      end

      crawl_session.increment!(:processed_count)

      page
    end

    # @param page [WebsitePage]
    # @param link [String]
    # @param origin_page_id [Integer]
    # @return [WebsiteResource]
    def save_not_found_page_link(page, origin_page_id:, link:)
      resource   = page.website.resources.find_by(url: link)
      resource ||= WebsiteResource.create!(website: page.website,
                                           url: link,
                                           effective_url: page.url,
                                           status: page.status,
                                           resource_type: 'link')

      return resource if WebsitePageWebsiteResource.exists?(website_page_id: origin_page_id,
                                                            website_resource_id: resource.id)

      WebsitePageWebsiteResource.create!(website_page_id: origin_page_id,
                                         website_resource_id: resource.id)

      resource
    rescue ActiveRecord::RecordNotUnique
      retry
    end

    # @param page [WebsitePage]
    # @return [Boolean]
    def perform_spellchecking?(page)
      return false unless page.website.preferences.check_spelling_and_grammar
      return false if page.url.include?('/sitemap')
      return false if page.url.end_with?('.xml')

      true
    end
  end
end
