# frozen_string_literal: true

module Api
  class WebsiteResourcesController < ApiBaseController
    load_and_authorize_resource

    def update
      if @website_resource.update(website_resource_params)
        render_json_api @website_resource
      else
        render_json_api_error @website_resource, status: :unprocessable_entity
      end
    end

    private

    def website_resource_params
      params.require(:website_resource).permit(:status)
    end
  end
end
