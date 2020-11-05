# frozen_string_literal: true

module Api
  class ReportShareableLinksController < ApiBaseController
    load_and_authorize_resource :website, parent: true

    def show
      render json: {
        data: {
          viewer: shared_url(token: JsonWebToken.encode(wid: @website.id, role: User::VIEWER)),
          editor: shared_url(token: JsonWebToken.encode(wid: @website.id, role: User::EDITOR))
        }
      }
    end
  end
end
