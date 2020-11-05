# frozen_string_literal: true

if Rails.env.test?
  # https://github.com/bblimke/webmock/issues/552
  module WebMock
    module HttpLibAdapters
      class TyphoeusAdapter < HttpLibAdapter
        def self.generate_typhoeus_response(request_signature, webmock_response)
          response = ::Typhoeus::Response.new(
            code: webmock_response.status[0],
            status_message: webmock_response.status[1],
            body: webmock_response.body,
            headers: webmock_response.headers,
            effective_url: standardize_stringify_uri(request_signature.uri)
          )
          response.mock = :webmock
          response
        end

        def self.standardize_stringify_uri(uri)
          return uri.omit(:port).to_s if [80, 443].include?(uri.port)

          uri.to_s
        end
      end
    end
  end
end
