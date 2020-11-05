# frozen_string_literal: true

module Api
  class WebsiteResourceSerializer
    include FastJsonapi::ObjectSerializer

    attributes :url,
               :status,
               :resource_type,
               :effective_url
  end
end
