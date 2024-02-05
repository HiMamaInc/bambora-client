# frozen_string_literal: true

module Bambora
  module Rest
    ##
    # The base class for making JSON requests.
    class JSONClient < Bambora::Rest::Client
      CONTENT_TYPE = 'application/json'

      # Make a GET Request.
      #
      # @example
      #
      #   client = Bambora::Rest::JSONClient(base_url: '...', merchant_id: '...')
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
      def get(path:, api_key:, params: nil)
        parse_response_body(
          super(path: path, params: params, headers: build_headers(api_key: api_key)),
        ).to_h
      end

      # Make a POST Request.
      #
      # @example
      #
      #   client = Bambora::Rest::JSONClient(base_url: '...', merchant_id: '...')
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
        parse_response_body(
          super(path: path, body: body.to_json.to_s, headers: build_headers(api_key: api_key)),
        ).to_h
      end

      # Make a DELETE Request.
      #
      # @example
      #
      #   client = Bambora::Rest::JSONClient(base_url: '...', api_key: '...', merchant_id: '...')
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
        parse_response_body(
          super(path: path, headers: build_headers(api_key: api_key)),
        ).to_h
      end

      # Make a PUT Request.
      #
      # @example
      #
      #   client = Bambora::Rest::JSONClient(base_url: '...', merchant_id: '...')
      #
      #   data = {
      #     billing: {
      #        name: "joh doe",
      #        address_line1: "123 main st",
      #        address_line2: "111",
      #        city: "victoria",
      #        province: "bc",
      #        country: "ca",
      #        postal_code: "V8T4M3",
      #        phone_number: "25012312345",
      #        email_address: "bill@smith.com"
      #     },
      #     card: {
      #       name: 'Hup Podling',
      #       number: '4030000010001234',
      #       expiry_month: '12',
      #       expiry_year: '23',
      #       cvd: '123',
      #     },
      #   }
      #
      #   client.put(
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
      # @param path [String] Indicating request path.
      # @param body [Hash] Data to be sent in the body of the request.
      # @param api_key [String] Indicating the API Key to be used with the request.
      #
      # @return [Hash] Indicating success or failure of the operation.
      def put(path:, body:, api_key:)
        parse_response_body(
          super(path: path, body: body.to_json.to_s, headers: build_headers(api_key: api_key)),
        ).to_h
      end

      private

      def build_headers(api_key:)
        super(api_key: api_key, content_type: CONTENT_TYPE)
      end
    end
  end
end
