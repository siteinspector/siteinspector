# frozen_string_literal: true

module Siteinspector
  module SkipUrls
    URLS = %w[
      zoom.us/webinar
      groups.yahoo.com/
      blogger.com/share-post
      twitter.com/intent
      twitter.com/share
      facebook.com/business
      click.linksynergy.com
      linkedin.com
      facebook.com/help
      facebook.com/pages
      google.com/search
      music.apple.com
      pinterest.com/pin/create/button
      google.co.in/maps
      blogspot.com
      google.com/maps
      vimeo.com
      quantumnewswire.com
      facebook.com/sharer
      instagram.com
      wa.me
      appsto.re
      help.instagram.com
      youtube.com
      api.whatsapp.com
      youtu.be
      scholar.google.com
      web.whatsapp.com
      chat.whatsapp.com
      trends.google.com
      tawk.to
    ].freeze

    SKIP_URLS_REGEXP = %r{\Ahttps?://(?:www\.)?(?:#{Regexp.union(URLS).source})}.freeze

    module_function

    # @param url [String]
    # @return [Boolean]
    def include?(url)
      SKIP_URLS_REGEXP.match?(url)
    end

    # @param pattern [String]
    # @param path [String]
    # @return [String]
    def match?(pattern, path)
      if pattern.ends_with?('*')
        path.starts_with?(pattern.delete_suffix('*'))
      else
        path == pattern
      end
    end
  end
end
