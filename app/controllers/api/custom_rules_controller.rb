# frozen_string_literal: true

module Api
  class CustomRulesController < ApiBaseController
    load_and_authorize_resource :website
    load_and_authorize_resource through: :website, shallow: true

    def index
      render_json_api @custom_rules.where(website: Website.enabled)
                                   .order(created_at: :desc)
                                   .preload(active_results: :website_page)
    end

    def show
      render_json_api @custom_rule
    end

    def create
      if @custom_rule.save!
        render_json_api @custom_rule
      else
        render_json_api_error @custom_rule, status: :unprocessable_entity
      end
    end

    def update
      if @custom_rule.update(custom_rule_params)
        render_json_api @custom_rule
      else
        render_json_api_error @custom_rule, status: :unprocessable_entity
      end
    end

    def destroy
      @custom_rule.destroy!

      head :ok
    end

    private

    def custom_rule_params
      params.require(:custom_rule).permit(:pattern, :condition, paths: [])
    end
  end
end
