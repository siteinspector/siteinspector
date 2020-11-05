# frozen_string_literal: true

module Websites
  module PreferencesSerializer
    DEFAULT_VALUES = {
      include_paths: [],
      exclude_paths: [],
      start_path: '/',
      exclude_words: [],
      check_spelling_and_grammar: true,
      check_links: true,
      check_images: true,
      check_scripts: true,
      exclude_xpath: ''
    }.freeze

    PreferencesStore = Struct.new(:include_paths,
                                  :exclude_paths,
                                  :exclude_words,
                                  :check_links,
                                  :check_spelling_and_grammar,
                                  :check_images,
                                  :check_scripts,
                                  :exclude_xpath,
                                  :start_path,
                                  keyword_init: true)

    module_function

    # @param object [Websites::PreferencesSerializer::PreferencesStore]
    # @return [Hash]
    def dump(object)
      object
    end

    # @param object [Object]
    # @return [Websites::PreferencesSerializer::PreferencesStore]
    def load(object)
      return unless object

      object = JSON.parse(object) if object.is_a?(String)
      data = DEFAULT_VALUES.merge(object.symbolize_keys)

      PreferencesStore.new(data.slice(*PreferencesStore.members))
    end
  end
end
