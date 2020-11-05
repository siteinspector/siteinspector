# frozen_string_literal: true

module Api
  class WebsitesController < ApiBaseController
    load_and_authorize_resource

    def index
      render_json_api @websites.enabled.order(:domain)
    end

    def show
      render_json_api @website
    end

    def create
      website = Websites.find_or_create_for_domain!(@website.domain)
      website.update!(preferences: @website.preferences)
      CustomRules.create_default_rule!(website)

      render_json_api website
    end

    def update
      if @website.update(website_params)
        render_json_api @website
      else
        render_json_api_error @website, status: :unprocessable_entity
      end
    end

    def destroy
      @website.update!(status: Website::DISABLED)

      render_json_api @website
    end

    private

    def website_params
      params.require(:website).permit(:domain, preferences: {})
    end
  end
end
