# frozen_string_literal: true

module Api
  class ReportsController < ApiBaseController
    load_and_authorize_resource :website, only: :show

    def show
      website =
        Website.preload(pages_with_errors: [:active_page_errors,
                                            { website_page_website_resources: :broken_link,
                                              active_custom_rule_results: :custom_rule }])
               .find_by(id: @website.id)

      render_json_api website, serializer: Api::ReportSerializer
    end
  end
end
