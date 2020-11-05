# frozen_string_literal: true

module WebsitePages
  module CheckCustomRules
    CONTEXT_SIZE = 60
    CONTEXT_PART_SIZE = CONTEXT_SIZE / 2
    REGEXP_PATTERN = %r{\A/(.*)/([a-z]{0,2})\z}.freeze

    module_function

    # @param page [WebsitePage]
    # @return [Array<CustomRuleResult>]
    def call(page)
      page.website.custom_rules.filter_map do |rule|
        next if rule.paths.any?(&:present?) &&
                rule.paths.none? { |pattern| Siteinspector::SkipUrls.match?(pattern, page.path) }

        result = process_rule(page, rule)

        rule.results.active.where(website_page: page).update_all(deleted_at: Time.current)

        next unless result

        result.save!

        result
      rescue ActiveRecord::RecordNotUnique
        result = rule.results.find_by(website_page: page, message: result.message)

        result.update!(deleted_at: nil)

        result
      end
    end

    # @param page [WebsitePage]
    # @param rule [CustomRule]
    # @return [CustomRuleResult, nil]
    def process_rule(page, rule)
      regexp = build_rule_regexp(rule)
      matches = page.doc.to_s.scan(regexp)

      return if matches.present? && rule.condition == CustomRule::CONTAIN
      return if matches.blank? && rule.condition == CustomRule::NOT_CONTAIN

      match = matches.first

      rule.results.new(
        message: build_result_message(page, rule, match),
        website_page: page
      )
    end

    # @param page [WebsitePage]
    # @param rule [CustomRule]
    # @param match [String]
    # @return [String]
    def build_result_message(page, rule, match)
      case rule.condition
      when CustomRule::CONTAIN
        "Does not contain #{rule.pattern}"
      when CustomRule::NOT_CONTAIN
        "Contains #{rule.pattern} near ...#{extract_context(page, match)}..."
      else
        raise ArgumentError
      end
    end

    # @param rule [CustomRule]
    # @return [Regexp]
    def build_rule_regexp(rule)
      _, pattern, modifiers = rule.pattern.match(REGEXP_PATTERN).to_a

      if pattern
        Regexp.new(pattern, Regexp::MULTILINE | (modifiers.include?('i') ? 1 : 0))
      else
        Regexp.new(Regexp.escape(rule.pattern), Regexp::MULTILINE | Regexp::IGNORECASE)
      end
    end

    # @param page [WebsitePage]
    # @param match [String]
    # @return [String]
    def extract_context(page, match)
      before, after = page.html.split(match, 2)

      [before.last(CONTEXT_PART_SIZE), match, after.first(CONTEXT_PART_SIZE)].join
    end
  end
end
