# frozen_string_literal: true

module Bambora
  class XMLClient < Bambora::RestClient
    include Bambora::Utils

    # Make a POST Request.
    #
    # @param path [String] Indicating request path.
    # @param body [Hash] Data to be sent in the body of the request.
    # @param api_key [String] Indicating the API Key to be used with the request.
    #
    # @return [Hash] Indicating success or failure of the operation.
    def post(path:, body:, api_key:)
      parse_response(
        super(path: path, body: Gyoku.xml(request: body), headers: build_headers(api_key)),
      )
    end

    private

    def build_headers(api_key)
      { 'Content-Type' => 'application/xml' }.merge(super(api_key))
    end

    def parse_response(resp)
      parsed_body = deep_transform_keys_in_object(parser.parse(resp.body), &:to_sym)
      return error_response(resp) if parsed_body.empty?

      parsed_body
    end

    def parser
      @parser ||= Nori.new
    end
  end
end
