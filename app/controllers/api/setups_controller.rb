# frozen_string_literal: true

module Api
  class SetupsController < ApiBaseController
    AlreadySetupError = Class.new(StandardError)

    skip_authorization_check

    def create
      raise AlreadySetupError if User.count.positive?

      user = User.new(user_params)

      if user.save
        sign_in(user)

        render_json_api user
      else
        render_json_api_error user, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password)
    end
  end
end
