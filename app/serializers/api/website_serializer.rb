# frozen_string_literal: true

module Api
  class WebsiteSerializer
    include FastJsonapi::ObjectSerializer

    attributes :id,
               :domain,
               :url,
               :slug,
               :preferences
  end
end
