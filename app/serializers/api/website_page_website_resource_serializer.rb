# frozen_string_literal: true

module Api
  class WebsitePageWebsiteResourceSerializer
    include FastJsonapi::ObjectSerializer

    attributes :is_resolved

    has_one :website_resource
    has_one :broken_link, serializer: :website_resource, record_type: :website_resource
  end
end
