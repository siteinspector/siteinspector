# frozen_string_literal: true

module Crawler
  class PageResult
    TYPES = [
      UPDATED = 'updated',
      NEW = 'new',
      FILE = 'file',
      EXTERNAL = 'external'
    ].freeze

    attr_accessor :page,
                  :type

    # @param type [String] Crawler::PageResult::TYPES
    # @param page [WebsitePage, nil]
    def initialize(type:, page: nil)
      @page = page
      @type = type
    end

    def external?
      type == EXTERNAL
    end

    def file?
      type == FILE
    end

    def new_page?
      type == NEW
    end
  end
end
