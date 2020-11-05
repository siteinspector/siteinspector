# frozen_string_literal: true

class CheckPageWorker
  include Sidekiq::Worker
  include Sidekiq::DynamicWorker

  TIMEOUT_DURATION = 2.minutes

  sidekiq_options retry: false

  # @param [Hash] params
  # @option params [Integer] 'crawl_session_id'
  # @option params [String] 'link'
  # @option params [Integer, nil] 'origin_page_id'
  def perform(params = {})
    crawl_session = CrawlSession.find(params.fetch('crawl_session_id'))

    return unless crawl_session.started?

    page =
      Timeout.timeout(TIMEOUT_DURATION) do
        Siteinspector::CheckPage.call(crawl_session, link: params.fetch('link'),
                                                     origin_page_id: params['origin_page_id'])
      end

    Siteinspector.enqueue_internal_links(crawl_session, page)
  rescue StandardError
    crawl_session.increment!(:error_count)

    raise
  end
end
