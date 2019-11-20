# frozen_string_literal: true

module Bambora
  class RestClient
    attr_accessor :base_url, :merchant_id, :sub_merchant_id

    # Initialze a client that makes REST requests. The RestClient is used by the JSONClient.
    #
    # @example
    #   rest_client = Bambora::RestClient.new(
    #     base_url: ENV.fetch('BAMBORA_BASE_URL'),
    #     merchant_id: ENV.fetch('BAMBORA_MERCHANT_ID'),
    #     sub_merchant_id: ENV.fetch('BAMBORA_SUB_MERCHANT_ID'),
    #   )
    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?
    end

    protected

    def get(path:, params:, headers:)
      connection.get(path, params, headers)
    end

    def post(path:, body:, headers:)
      connection.post(path, body, headers)
    end

    def delete(path:, headers:)
      connection.delete(path) do |req|
        req.headers = headers
      end
    end

    def connection
      @connection ||= Faraday.new(url: base_url) do |f|
        f.adapter :excon
      end
    end

    def build_headers(api_key)
      Bambora::Headers.build(api_key: api_key, merchant_id: merchant_id, sub_merchant_id: sub_merchant_id)
    end

    def error_response(resp)
      { status: resp.status, body: resp.body }
    end
  end
end
