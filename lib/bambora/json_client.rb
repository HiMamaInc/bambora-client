# frozen_string_literal: true

module Bambora
  class JSONClient < Bambora::RestClient
    # Make a GET Request.
    #
    # @example
    #
    #   client = Bambora::JSONClient(base_url: '...', merchant_id: '...')
    #
    #   client.get(
    #     path: 'v1/profiles',
    #     params: '...',
    #     api_key: '...'
    #   )
    #   # => {
    #   #      :code => 1,
    #   #      :message => "Operation Successful",
    #   #      :customer_code => "02355E2e58Bf488EAB4EaFAD7083dB6A",
    #   #      :card => { ... }
    #   #    }
    #
    # @param path [String] Indicating request path.
    # @param params [Hash] Query parameters for the request.
    # @param api_key [String] Indicating the API Key to be used with the request.
    #
    # @return [Hash] Indicating success or failure of the operation.
    def get(path:, params: nil, api_key:)
      Bambora::JSONResponse.new(
        super(path: path, params: params, headers: build_headers(api_key: api_key)),
      ).to_h
    end

    # Make a POST Request.
    #
    # @example
    #
    #   client = Bambora::JSONClient(base_url: '...', merchant_id: '...')
    #
    #   data = {
    #    language: 'en',
    #     card: {
    #       name: 'Hup Podling',
    #       number: '4030000010001234',
    #       expiry_month: '12',
    #       expiry_year: '23',
    #       cvd: '123',
    #     },
    #   }
    #
    #   client.post(
    #     path: 'v1/profiles',
    #     body: data,
    #     api_key: '...'
    #   )
    #   # => {
    #   #      :code => 1,
    #   #      :message => "Operation Successful",
    #   #      :customer_code => "02355E2e58Bf488EAB4EaFAD7083dB6A",
    #   #    }
    #
    # @param method [Symbol] Indicating request verb.
    # @param path [String] Indicating request path.
    # @param body [Hash] Data to be sent in the body of the request.
    # @param api_key [String] Indicating the API Key to be used with the request.
    #
    # @return [Hash] Indicating success or failure of the operation.
    def post(path:, body:, api_key:)
      Bambora::JSONResponse.new(
        super(path: path, body: body.to_json.to_s, headers: build_headers(api_key: api_key)),
      ).to_h
    end

    # Make a DELETE Request.
    #
    # @example
    #
    #   client = Bambora::JSONClient(base_url: '...', api_key: '...', merchant_id: '...')
    #
    #   client.delete(path: 'v1/profiles/02355E2e58Bf488EAB4EaFAD7083dB6A', api_key: '...')
    #   # => {
    #   #      :code => 1,
    #   #      :message => "Operation Successful",
    #   #      :customer_code => "02355E2e58Bf488EAB4EaFAD7083dB6A",
    #   #    }
    #
    # @param path [String] Indicating request path.
    # @param api_key [String] Indicating the API Key to be used with the request.
    #
    # @return [Hash] Indicating success or failure of the operation.
    def delete(path:, api_key:)
      Bambora::JSONResponse.new(
        super(path: path, headers: build_headers(api_key: api_key)),
      ).to_h
    end
  end
end
