# frozen_string_literal: true

module UrlUtils
  module_function

  # @param url [String]
  # @return [String]
  def remove_fragment(url)
    Addressable::URI.parse(url).tap { |e| e.fragment = nil }.normalize.to_s
  end

  # @param url [String]
  # @return [String]
  def extract_domain(url)
    url.sub(%r{\Ahttps?://(?:www\.)?}, '').split(%r{[/?]}).first
  end

  # @param link [String]
  # @return [String]
  def extract_path(link)
    Addressable::URI.parse(link).tap { |e| e.fragment = nil }.normalize.path
  rescue Addressable::URI::InvalidURIError
    link
  end

  # @param url [String]
  # @return [String]
  def extract_root_url(url)
    Addressable::URI.parse(url).tap { |e| e.path = nil if e.host.present? }.to_s
  end

  # @param url [String]
  # @return [String]
  def extract_extension(url)
    extension = File.extname(Addressable::URI.parse(url).path).tr('.', '')

    extension || link[/\.(\w{2,4})\z/, 1]
  end

  # @param base_url [String]
  # @param relative_path [String]
  # @return [String]
  def join_url(base_url, relative_path)
    url = Addressable::URI.parse(base_url)
    path = Addressable::URI.parse(relative_path)

    return path.normalize.to_s if path.absolute?

    url.path = url.normalized_path

    (url + path).to_s
  end

  # @param link [String]
  # @return [Boolean]
  def relative?(link)
    !link.match?(%r{\A(?:(?:http)|/)})
  end

  # @param link [String]
  # @return [Boolean]
  def file?(link)
    extension = UrlUtils.extract_extension(link)

    extension.present? &&
      extension.length < 5 &&
      Tld::ALL.exclude?(extension) &&
      Crawler::HTML_EXTENSIONS.exclude?(extension)
  end

  # @param link [String]
  # @param domain [String]
  # @return [Boolean]
  def internal?(link, domain)
    return true unless link.match?(%r{\A(?:https?:)?//})

    UrlUtils.extract_domain(link) == domain
  end
end
