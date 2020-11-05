# frozen_string_literal: true

module Api
  class CrawlSessionsCancelController < ApiBaseController
    load_and_authorize_resource :crawl_session, parent: true

    def create
      if @crawl_session.update!(status: CrawlSession::CANCELED)
        Sidekiq::DynamicQueues::Queue.new(@crawl_session.website.domain).clear

        render_json_api @crawl_session
      else
        render_json_api_error @crawl_session, status: :unprocessable_entity
      end
    end
  end
end
