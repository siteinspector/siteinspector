# frozen_string_literal: true

class ApiBaseController < ActionController::API
  check_authorization

  def render_json_api(object, options = {})
    render json: JsonApiUtils.render(object, params, options), status: :ok
  end

  def render_json_api_error(object, options = {})
    render({ status: :unprocessable_entity }.merge(options.merge(json: JsonApiUtils.render(object))))
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, session)
  end
end
