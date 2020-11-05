# frozen_string_literal: true

module Api
  class WebsitePageErrorsMarkFalsePositiveController < ApiBaseController
    load_and_authorize_resource :website_page_error

    def create
      ApplicationRecord.transaction do
        @website_page_error.website
                           .active_page_errors
                           .where(text: @website_page_error.text, context: @website_page_error.context)
                           .update_all(error_type: WebsitePageError::FALSE_POSITIVE)

        if params[:permanent]
          @website_page_error.website
                             .active_page_errors
                             .where(text: @website_page_error.text)
                             .update_all(error_type: WebsitePageError::FALSE_POSITIVE)

          @website_page_error.website.preferences.exclude_words << @website_page_error.text.downcase
          @website_page_error.website.save!
        end
      end

      head :ok
    end
  end
end
