# frozen_string_literal: true

module Crawler
  module LoadPage
    MAX_SIZE = 7.megabytes

    ALLOW_MIME_TYPES = %w[
      text/html
      application/xhtml+xml
      application/xml
      application/x-php
      application/atom+xml
      application/x-perl
    ].freeze

    module_function

    # @param website [Website]
    # @param link [String]
    # @return [WebsitePage]
    def call(website, link)
      absolute_url = UrlUtils.join_url(website.url, link)

      resp = Crawler::Conn.call(:get, absolute_url)

      begin
        result = load_existing_page_result(website, resp) || load_page_result(website, resp)

        save_page!(result.page, absolute_url) if result.new_page?

        result
      rescue ActiveRecord::RecordNotUnique
        retry
      end
    end

    # @param website [Website]
    # @param resp [Typhoeus::Response]
    # @return [Crawler::PageResult]
    def load_page_result(website, resp)
      page = build_page(website, resp)

      return PageResult.new(page: page, type: PageResult::EXTERNAL) unless same_domain?(website, resp.effective_url)
      return PageResult.new(page: page, type: PageResult::FILE) unless html_page?(resp)

      PageResult.new(page: page, type: PageResult::NEW)
    end

    # @param website [Website]
    # @param resp [Typhoeus::Response]
    # @return [Crawler::PageResult, nil]
    def load_existing_page_result(website, resp)
      where_urls = [resp.effective_url, resp.effective_url.delete_suffix('/')]

      existing_page = website.pages.where(sha1: Digest::SHA1.hexdigest(resp.body), url: where_urls).take

      return unless existing_page

      existing_page.html = TextUtils.fix_encoding(resp.body)

      ApplicationRecord.transaction do
        website.pages.active.where(url: where_urls).update_all(deleted_at: Time.current)

        existing_page.update_columns(deleted_at: nil, updated_at: Time.current)
      end

      PageResult.new(page: existing_page, type: PageResult::UPDATED)
    end

    # @param page [WebsitePage]
    # @return [WebsitePage]
    def page_exists?(page)
      page.website.website_pages.exists?(sha1: page.sha1, url: page.url)
    end

    # @param website [Website]
    # @param url [String]
    # @return [Boolean]
    def same_domain?(website, url)
      website.domain == UrlUtils.extract_domain(url)
    end

    # @param resp [Typhoeus::Response]
    # @return [Boolean]
    def html_page?(resp)
      return true if resp.effective_url.include?('sitemap')
      return false if resp.body.size > MAX_SIZE
      return true if resp.body.include?('<html')

      content_type = Marcel::MimeType.for(resp.body)

      return true if content_type.in?(ALLOW_MIME_TYPES)
      return true if content_type == 'application/octet-stream' &&
                     resp.response_headers.include?('text/html')

      false
    end

    # @param website [Website]
    # @param resp [Typhoeus::Response]
    # @return [WebsitePage]
    def build_page(website, resp)
      website.pages.new do |p|
        p.sha1 = Digest::SHA1.hexdigest(resp.body)
        p.url = resp.effective_url
        p.status = Crawler.fetch_status(resp)
        p.html = TextUtils.fix_encoding(resp.body)
      end
    end

    # @param page [WebsitePage]
    # @param link [String]
    # @return [WebsitePage]
    def save_page!(page, link)
      ApplicationRecord.transaction do
        page.website.pages.where(deleted_at: nil)
            .where(url: [page.url, link])
            .update_all(deleted_at: Time.current)

        page.save!
      end

      page
    end
  end
end
