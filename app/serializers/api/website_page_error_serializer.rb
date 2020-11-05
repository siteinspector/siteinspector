# frozen_string_literal: true

module Api
  class WebsitePageErrorSerializer
    include FastJsonapi::ObjectSerializer

    attributes :text,
               :correction,
               :context,
               :status,
               :error_type
  end
end
