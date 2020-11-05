# frozen_string_literal: true

module WebsitePages
  module Spellcheck
    module_function

    # @param page [WebsitePage]
    # @return [Array<WebsitePageError>]
    def call(page)
      mistakes = Spellchecker.check(page.raw_text)

      mistakes.map do |mistake|
        next if skip_mistake?(mistake, page.website)

        attrs = mistake.to_h.slice(:text, :context, :correction)

        page.page_errors.create!(attrs.merge(error_type: mistake.type))
      rescue ActiveRecord::RecordNotUnique
        page.page_errors.find_by(attrs)
      end
    end

    # @param mistake [WebsitePageError]
    # @param website [Website]
    # @return [Boolean]
    def skip_mistake?(mistake, website)
      return true unless CLD.detect_language(mistake.context)[:code] == 'en'
      return true if mistake.text.downcase.in?(website.preferences.exclude_words)
      return true if WebsitePageError.joins(:website_page)
                                     .where(website_page: { website: website })
                                     .exists?(text: mistake.text,
                                              context: mistake.context,
                                              correction: mistake.correction,
                                              error_type: WebsitePageError::FALSE_POSITIVE)

      false
    end
  end
end
