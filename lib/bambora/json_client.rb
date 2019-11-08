# frozen_string_literal: true

module Bambora
  class JSONClient < Bambora::Client
    # Make a JSON Request.
    #
    # @example
    #
    #   client = Bambora::JSONClient(base_url: '...', api_key: '...', merchant_id: '...')
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
    #   client.request(
    #     method: :post,
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
    # @param body [Hash] Data to be sent in the body of the request. This should be a Hash or an object that responds
    #   to +to_hash+.
    # @param api_key [String] Indicating the API Key to be used with the request.
    #
    # @return [Hash] Indicating success or failure of the operation.
    def request(method:, path:, body: {}, api_key:)
      request_options = {
        method: method,
        path: path,
        body: request_body(body),
        headers: headers(api_key),
      }
      resp = connection.request(request_options)
      parse_response(resp)
    rescue JSON::ParserError
      error_response(resp)
    end

    private

    def headers(api_key)
      { 'Content-Type' => 'application/json' }.merge(super(api_key))
    end

    def parse_response(resp)
      deep_transform_keys_in_object(JSON.parse(resp.body), &:to_sym)
    end

    def deep_transform_keys_in_object(object, &block)
      case object
        when Hash
          object.each_with_object({}) do |(key, value), result|
            result[yield(key)] = deep_transform_keys_in_object(value, &block)
          end
        when Array
          object.map { |e| deep_transform_keys_in_object(e, &block) }
        else
          object
      end
    end

    def error_response(resp)
      { status: resp.status, body: resp.body }
    end

    def request_body(body)
      JSON.unparse(body)
    end
  end
end
