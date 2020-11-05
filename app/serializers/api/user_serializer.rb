# frozen_string_literal: true

module Api
  class UserSerializer
    include FastJsonapi::ObjectSerializer

    attributes :id,
               :email,
               :first_name,
               :last_name,
               :role
  end
end
