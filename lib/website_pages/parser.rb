# frozen_string_literal: true

module WebsitePages
  module Parser
    TITLE_LIMIT = 200
    MAX_LINK_LENGTH = 2_000

    module_function

    # @param doc [Nokogiri::HTML::Document]
    # @return [Nokogiri::HTML::Document]
    def clear_doc(doc)
      doc.search("//*[starts-with(@class, 'comment')]").each(&:remove)
      doc.search("//*[starts-with(@id, 'comment')]").each(&:remove)
      doc.search("//*[@id='reviews']").each(&:remove)
      doc.search('//script').each { |e| e.inner_html = '' }
      doc.search('//code').each(&:remove)
      doc.search('//noscript').each(&:remove)
      doc.search('//style').each(&:remove)
      doc.search('//blockquote').each(&:remove)

      doc
    end

    # @param doc [Nokogiri::HTML::Document]
    # @return [String]
    def parse_title(doc)
      doc.xpath('//title/text()').first&.text.to_s.squish.truncate(TITLE_LIMIT)
    end

    # @param doc [Nokogiri::HTML::Document]
    # @param join_string [String]
    # @return [String]
    def parse_text(doc, join_string = ' ')
      doc.xpath('//*/text()').map { |e| e.text.strip }.select(&:present?).join(join_string)
    end

    # @param doc [Nokogiri::HTML::Document]
    # @return [Array<String>]
    def parse_images(doc)
      links = doc.xpath('//img/@src').map(&:text)

      normalize_links(links).reject do |link|
        link.match?(%r{^(?:data:|image/)})
      end
    end

    # @param doc [Nokogiri::HTML::Document]
    # @return [Array<String>]
    def parse_scripts(doc)
      links = doc.xpath('//script/@src').map(&:text)

      normalize_links(links)
    end

    # @param doc [Nokogiri::HTML::Document]
    # @return [Array<String>]
    def parse_styles(doc)
      links = doc.xpath('//link[@rel="stylesheet"]/@href').map(&:text)

      normalize_links(links)
    end

    # @param doc [Nokogiri::HTML::Document]
    # @return [Array<String>]
    def parse_links(doc)
      links   = doc.xpath('//a/@href').map(&:text).presence
      links ||= doc.xpath('//loc/url').map(&:text).presence
      links ||= doc.xpath('//item/link').map(&:text).presence
      links ||= URI.extract(doc.to_s).select { |e| e.starts_with?('http') }

      normalize_links(links).reject do |link|
        link.match?(/^(?:javascript:|tel:|mailto:|data:|image:|#)/)
      end
    end

    # @param links [Array<String>]
    # @return [Array<String>]
    def normalize_links(links)
      links.map(&:strip).map { |e| e.split('#').first }.uniq.select do |link|
        link.present? && link.length < MAX_LINK_LENGTH
      end
    end
  end
end
