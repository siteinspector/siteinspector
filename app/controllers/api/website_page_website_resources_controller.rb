# frozen_string_literal: true

module Api
  class WebsitePageWebsiteResourcesController < ApiBaseController
    load_and_authorize_resource

    def update
      if @website_page_website_resource.update(website_page_website_resource_params)
        render_json_api @website_page_website_resource
      else
        render_json_api_error @website_page_website_resource, status: :unprocessable_entity
      end
    end

    private

    def website_page_website_resource_params
      params.require(:website_page_website_resource).permit(:is_resolved)
    end
  end
end
