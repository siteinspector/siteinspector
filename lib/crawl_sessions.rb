# frozen_string_literal: true

module CrawlSessions
  SESSION_MAX_DURATION = 1.hour

  module_function

  # @param session [CrawlSession]
  # @return [CrawlSession]
  def update_status(session)
    return if session.status != CrawlSession::CREATED &&
              Sidekiq::DynamicQueues::Queue.new(session.website.domain).size.positive?
    return if !session.finished? && session.created_at < SESSION_MAX_DURATION.ago

    if session.processed_count.positive?
      session.update!(status: CrawlSession::COMPLETED)
    elsif session.created_at < SESSION_MAX_DURATION.ago
      session.update!(status: CrawlSession::FAILED)
    end

    session
  end
end
