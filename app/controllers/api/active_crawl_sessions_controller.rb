# frozen_string_literal: true

module Api
  class ActiveCrawlSessionsController < ApiBaseController
    load_and_authorize_resource :website

    def show
      crawl_session = @website.crawl_sessions.order(:created_at)
                              .where(status: [CrawlSession::STARTED, CrawlSession::CREATED]).take

      CrawlSessions.update_status(crawl_session) if crawl_session

      render_json_api crawl_session
    end
  end
end
