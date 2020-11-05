# frozen_string_literal: true

module Crawler
  module Conn
    RETRY_INTERVAL = 2
    TIMEOUT = 20

    ACCEPT_LANGUAGE = 'en-us'

    USER_AGENT = <<~UA.squish
      Mozilla/5.0+(compatible; SiteInspector/1.0; https://github.com/siteinspector/siteinspector)
    UA

    RequestError = Class.new(StandardError)

    module_function

    # @param method [String]
    # @param url [String]
    # @param params [Hash]
    # @param headers [Hash]
    # @param retries [Boolean]
    # @return [Typhoeus::Response]
    def call(method, url, params: {}, headers: {}, retries: true)
      req = build_request(method, url, params, headers)

      run_request(req, retries: retries)
    end

    # @param req [Typhoeus::Request]
    # @param retries [Boolean]
    # @return [Typhoeus::Response]
    def run_request(req, retries: true)
      resp = req.run

      if retries && resp.return_code != :ok
        sleep(RETRY_INTERVAL)

        resp = req.run
      end

      resp
    end

    # @param method [String]
    # @param url [String]
    # @param params [Hash]
    # @param headers [Hash]
    # @return [Typhoeus::Request]
    def build_request(method, url, params = {}, headers = {})
      Typhoeus::Request.new(
        url,
        followlocation: true,
        timeout: TIMEOUT,
        connecttimeout: TIMEOUT,
        method: method,
        params: params,
        ssl_verifyhost: 0,
        ssl_verifypeer: false,
        accept_encoding: 'gzip',
        headers: {
          'Accept-Language' => ACCEPT_LANGUAGE,
          'User-Agent' => USER_AGENT,
          'Accept-Encoding' => 'gzip'
        }.merge(headers)
      )
    end
  end
end
