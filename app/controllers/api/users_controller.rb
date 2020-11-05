# frozen_string_literal: true

module Api
  class UsersController < ApiBaseController
    load_and_authorize_resource

    def index
      render_json_api @users
    end

    def show
      render_json_api @user
    end

    def create
      if @user.save!
        render_json_api @user
      else
        render_json_api_error @user, status: :unprocessable_entity
      end
    end

    def update
      if @user.update(user_params)
        render_json_api @user
      else
        render_json_api_error @user, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy!

      head :ok
    end

    private

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password)
    end
  end
end
