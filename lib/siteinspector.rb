# frozen_string_literal: true

module Siteinspector
  module_function

  # @param crawl_session [CrawlSession]
  # @return [CrawlSession]
  def call(crawl_session)
    crawl_session.increment!(:enqueued_count)
    crawl_session.update!(status: CrawlSession::STARTED)

    Crawler::LinksStore.clear(crawl_session.id)

    website = crawl_session.website

    result = Crawler::LoadPage.call(website, website.url)

    Siteinspector::CheckPage.process_page(crawl_session, result.page)

    enqueue_internal_links(crawl_session, result.page)
    enqueue_pages_with_errors(crawl_session)

    crawl_session
  end

  # @param crawl_session [CrawlSession]
  # @return [Array<String>] job ids
  def enqueue_pages_with_errors(crawl_session)
    crawl_session.website.active_pages.with_errors.filter_map do |page|
      next if skip_link?(crawl_session.website, page.url)

      enqueue_page(crawl_session, origin_page_id: page.id, link: page.url)
    end
  end

  # @param crawl_session [CrawlSession]
  # @param page [WebsitePage]
  # @return [Array<String>] job ids
  def enqueue_internal_links(crawl_session, page)
    page.internal_links.filter_map do |link|
      link = UrlUtils.join_url(page.url, link) if UrlUtils.relative?(link)

      next if skip_link?(page.website, link)
      next unless Crawler::LinksStore.push(crawl_session.id, link)

      enqueue_page(crawl_session, origin_page_id: page.id, link: link)
    end
  end

  # @param website [Website]
  # @param link [String]
  # @return [Array<String>] job ids
  def skip_link?(website, link)
    path = UrlUtils.extract_path(link)

    is_included = website.preferences.include_paths.any? { |pattern| Siteinspector::SkipUrls.match?(pattern, path) }
    is_excluded = website.preferences.exclude_paths.any? { |pattern| Siteinspector::SkipUrls.match?(pattern, path) }

    return true if Siteinspector::SkipUrls.include?(path) && !is_included
    return true if is_excluded && !is_included

    false
  end

  # @param crawl_session [CrawlSession]
  # @param link [String]
  # @param origin_page_id [Integer]
  # @return [String]
  def enqueue_page(crawl_session, link:, origin_page_id:)
    crawl_session.increment!(:enqueued_count)

    CheckPageWorker.set(dynamic_queue: crawl_session.website.domain)
                   .perform_async('crawl_session_id' => crawl_session.id,
                                  'origin_page_id' => origin_page_id,
                                  'link' => link)
  end

  # @param page [WebsitePage]
  # @param links [Array<String>]
  # @param type [String] Crawler::RESOURCE_TYPES
  # @return [Array<String>]
  def enqueue_resources(page:, links:, type: nil)
    links.filter_map do |link|
      next if skip_link?(page.website, link)

      CheckResourceWorker.set(dynamic_queue: page.website.domain)
                         .perform_async('website_page_id' => page.id, 'link' => link, 'type' => type)
    end
  end
end
