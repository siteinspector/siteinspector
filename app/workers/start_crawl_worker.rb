# frozen_string_literal: true

class StartCrawlWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  # @param [Hash] params
  # @option params [Integer] 'crawl_session_id'
  def perform(params = {})
    crawl_session = CrawlSession.find(params.fetch('crawl_session_id'))

    Websites.update_website(crawl_session.website)

    Siteinspector.call(crawl_session)
  rescue StandardError
    crawl_session.update!(status: CrawlSession::FAILED)

    raise
  end
end
