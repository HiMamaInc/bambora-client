# frozen_string_literal: true

module Bambora
  module Rest
    # The base class for making XML requests.
    class XMLClient < Bambora::Rest::Client
      CONTENT_TYPE = 'application/xml'
      RESPONSE_FORMAT = 'JSON'

      ##
      # Make a POST Request.
      #
      # @param path [String] Indicating request path.
      # @param body [Hash] Data to be sent in the body of the request.
      # @param api_key [String] Indicating the API Key to be used with the request.
      #
      # @return [Hash] Indicating success or failure of the operation.
      def post(path:, body:, api_key:)
        parse_response_body(
          super(
            path: path,
            body: Bambora::Builders::XMLRequestBody.new(body: body).to_s,
            headers: build_headers,
          ),
        )
      end

      private

      def build_headers
        { 'Content-Type' => CONTENT_TYPE }
      end
    end
  end
end
