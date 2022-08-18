# frozen_string_literal: true

module Api
  class CrawlSessionsController < ApiBaseController
    load_and_authorize_resource :website
    load_and_authorize_resource through: :website, shallow: true

    LIMIT = 50

    def index
      render_json_api @crawl_sessions.order(created_at: :desc).limit(LIMIT)
    end

    def create
      if @crawl_session.save!
        StartCrawlWorker.perform_async('crawl_session_id' => @crawl_session.id)

        render_json_api @crawl_session
      else
        render_json_api_error @crawl_session, status: :unprocessable_entity
      end
    end

    def update
      if @crawl_session.update(crawl_session_params)
        render_json_api @crawl_session
      else
        render_json_api_error @crawl_session, status: :unprocessable_entity
      end
    end

    private

    def crawl_session_params
      params.require(:crawl_session).permit(:status)
    end
  end
end
