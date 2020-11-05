# frozen_string_literal: true

module Api
  class CustomRuleResultSerializer
    include FastJsonapi::ObjectSerializer

    attributes :id,
               :message

    has_one :website_page
    has_one :custom_rule
  end
end
