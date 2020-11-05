# frozen_string_literal: true

module CustomRules
  DEFAULT_RULE_TEXT = 'Lorem ipsum dolor sit'

  module_function

  # @param website [Website]
  # @return [CustomRule]
  def create_default_rule!(website)
    website.custom_rules
           .create_with(condition: CustomRule::NOT_CONTAIN)
           .find_or_create_by!(pattern: DEFAULT_RULE_TEXT)
  end
end
