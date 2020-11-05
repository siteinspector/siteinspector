# frozen_string_literal: true

module Api
  class WebsitePageSerializer
    include FastJsonapi::ObjectSerializer

    attributes :title,
               :url,
               :status

    has_many :page_errors, record_type: :website_page_error,
                           serializer: :website_page_error
    has_many :website_page_website_resources
    has_many :custom_rule_results
  end
end
