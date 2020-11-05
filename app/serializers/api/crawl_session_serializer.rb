# frozen_string_literal: true

module Api
  class CrawlSessionSerializer
    include FastJsonapi::ObjectSerializer

    attributes :status,
               :enqueued_count,
               :processed_count,
               :error_count,
               :created_at,
               :updated_at

    attribute :queue_size do |object|
      Sidekiq::DynamicQueues::Queue.new(object.website.domain).size
    end
  end
end
