# frozen_string_literal: true

class SharedReportController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    jwt_payload = JsonWebToken.decode(params[:token])

    website_id, role = jwt_payload.values_at(:wid, :role)

    return authenticate_user! unless website_id

    session[:jwt_payload] = jwt_payload.to_json

    @data_attrs = build_data_attrs(website_id, role)

    render 'ui/show'
  rescue JWT::DecodeError
    authenticate_user!
  end

  private

  def build_data_attrs(website_id, role)
    {
      user: { id: -1, email: 'shared@report', role: role },
      websites: Website.where(id: website_id)
                       .as_json(only: %i[id domain url slug status])
    }
  end
end
