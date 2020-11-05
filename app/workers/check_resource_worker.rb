# frozen_string_literal: true

class CheckResourceWorker
  include Sidekiq::Worker
  include Sidekiq::DynamicWorker

  TIMEOUT_DURATION = 1.minute

  sidekiq_options retry: false

  # @param [Hash] params
  # @option params [Integer] 'website_page_id'
  # @option params [String] 'link'
  # @option params [String, nil] 'type' Crawler::RESOURCE_TYPES
  def perform(params = {})
    page = WebsitePage.find(params.fetch('website_page_id'))

    Timeout.timeout(TIMEOUT_DURATION) do
      Siteinspector::CheckResource.call(page, params.fetch('link'), type: params['type'])
    end
  end
end
