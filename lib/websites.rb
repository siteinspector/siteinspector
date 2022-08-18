# frozen_string_literal: true

module Websites
  module_function

  # @param domain [String]
  # @return [Website]
  def find_or_create_for_domain!(domain)
    attrs = load_website_attrs(domain.strip)

    website = Website.find_by(domain: attrs[:domain])

    if website
      website.update!(attrs)

      website
    else
      Website.create!(attrs)
    end
  end

  # @param website [Website]
  # @return [Website]
  def update_website(website)
    attrs = load_website_attrs(website.domain)

    website.update!(attrs)

    website
  end

  # @param domain [String]
  # @return [Hash]
  def load_website_attrs(domain)
    domain = UrlUtils.extract_domain(domain)

    resp = Crawler::Conn.call(:get, domain)
    resp = Crawler::Conn.call(:get, "www.#{domain}") if resp.return_code != :ok

    url = UrlUtils.extract_root_url(resp.effective_url)
    domain = UrlUtils.extract_domain(url)

    { url: url, domain: domain }
  end

  # @param website [Website]
  # @return [Hash<Symbol, Integer>]
  def load_stats(website)
    grammar_mistakes, spelling_mistakes =
      website.pages_with_errors.flat_map(&:active_page_errors).partition do |e|
        e.error_type == WebsitePageError::GRAMMAR
      end

    broken_links_count =
      website.pages_with_errors.sum do |e|
        e.website_page_website_resources.filter_map(&:broken_link).length
      end

    {
      broken_links: broken_links_count,
      spelling_mistakes: spelling_mistakes.size,
      grammar_mistakes: grammar_mistakes.size,
      pages_count: website.active_pages.count,
      custom_rules: website.pages_with_errors.sum { |e| e.active_custom_rule_results.size }
    }
  end
end
