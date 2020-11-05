# frozen_string_literal: true

module Api
  class WebsitePageErrorsController < ApiBaseController
    load_and_authorize_resource

    def update
      if @website_page_error.update(website_page_error_params)
        render_json_api @website_page_error
      else
        render_json_api_error @website_page_error, status: :unprocessable_entity
      end
    end

    private

    def website_page_error_params
      params.require(:website_page_error).permit(:status)
    end
  end
end
