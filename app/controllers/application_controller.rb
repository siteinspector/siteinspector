# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :maybe_redirect_to_setup
  before_action :maybe_redirect_from_setup

  before_action :test_backdoor_authentication
  before_action :authenticate_user!, unless: :setup_path?

  private

  def maybe_redirect_to_setup
    return if setup_path?
    return unless new_setup?

    redirect_to setup_path
  end

  def maybe_redirect_from_setup
    return unless setup_path?
    return if new_setup?

    redirect_to dashboard_path
  end

  def new_setup?
    current_user.nil? && User.count.zero?
  end

  def setup_path?
    request.path == setup_path
  end

  def test_backdoor_authentication
    return unless Rails.env.test?
    return unless params[:user_id]

    sign_in User.find(params[:user_id])
  end
end
