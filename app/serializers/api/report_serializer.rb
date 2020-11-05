# frozen_string_literal: true

module Api
  class ReportSerializer
    include FastJsonapi::ObjectSerializer

    attributes :domain, :slug, :url

    has_many :pages, record_type: :report_page,
                     serializer: :report_page,
                     object_method_name: :pages_with_errors,
                     id_method_name: :pages_with_error_ids

    attribute :stats do |obj|
      Websites.load_stats(obj)
    end
  end
end
