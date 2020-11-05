# frozen_string_literal: true

module Crawler
  STATUSES = [
    OK = 'ok',
    NOT_FOUND = 'not_found',
    BROKEN = 'broken',
    UNAVAILABLE = 'unavailable',
    UNKNOWN = 'unknown'
  ].freeze

  RESOURCE_TYPES = [
    SCRIPT = 'script',
    STYLE = 'style',
    IMAGE = 'image',
    VIDEO = 'video',
    FILE = 'file',
    LINK = 'link'
  ].freeze

  HTML_EXTENSIONS = Set.new(%w[html htm cfm htmlx cfml aspx asp asx cgi
                               hta htc php php3 php4 php5 pl jsp jspx haml
                               slim rb yaml stm do xml]).freeze

  module_function

  # @param resp [Typhoeus::Response]
  # @return [String] WebsitePage::STATUSES
  def fetch_status(resp)
    return OK if resp.response_code.to_i >= 600
    return OK if resp.response_code.to_i == 403
    return OK if (resp.response_code / 100).in?([2, 3])
    return NOT_FOUND if resp.response_code.to_i == 404
    return BROKEN if resp.response_code.to_i == 500
    return UNAVAILABLE if resp.response_code.zero? && resp.return_code == :couldnt_resolve_host

    UNKNOWN
  end

  # @param resp [Typhoeus::Response]
  # @return [String] WebsiteResource::TYPES
  def fetch_resource_type(resp)
    extension = UrlUtils.extract_extension(resp.effective_url)

    return LINK if extension.length < 2 || extension.length > 4
    return LINK if HTML_EXTENSIONS.include?(extension)

    content_type   = Marcel::MimeType.for(extension: extension) if extension.present?
    content_type ||= resp.headers['Content-Type'] || resp.headers['content-type']

    content_type_to_resource_type(content_type)
  end

  # @param content_type [String]
  # @return [String] Crawler::RESOURCE_TYPES
  def content_type_to_resource_type(content_type)
    if content_type == 'application/javascript'
      SCRIPT
    elsif content_type == 'text/css'
      STYLE
    elsif content_type.include?('image')
      IMAGE
    elsif content_type.include?('video')
      VIDEO
    else
      FILE
    end
  end
end
