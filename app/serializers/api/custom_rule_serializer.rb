# frozen_string_literal: true

module Api
  class CustomRuleSerializer
    include FastJsonapi::ObjectSerializer

    attributes :id,
               :condition,
               :pattern,
               :paths,
               :website_id

    has_many :results, record_type: :custom_rule_result,
                       serializer: :custom_rule_result,
                       object_method_name: :active_results,
                       id_method_name: :active_result_ids
  end
end
