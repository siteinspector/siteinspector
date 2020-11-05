# frozen_string_literal: true

class UiController < ApplicationController
  before_action :assign_data_attrs

  def index
    render :show
  end

  def show; end

  private

  def assign_data_attrs
    @data_attrs = {
      websites: Website.enabled.as_json(only: %i[id domain url slug status])
    }

    return unless current_user

    @data_attrs[:user] = current_user.as_json(only: %i[id email first_name last_name], methods: %i[role])
  end
end
