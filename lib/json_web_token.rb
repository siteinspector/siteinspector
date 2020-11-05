# frozen_string_literal: true

module JsonWebToken
  module_function

  # @param payload [Hash]
  # @return [String]
  def encode(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  # @param token [String]
  # @return [HashWithIndifferentAccess]
  def decode(token)
    body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]

    HashWithIndifferentAccess.new(body)
  end
end
