# frozen_string_literal: true

module Bambora
  # The base class for making XML requests.
  class XMLClient < Bambora::RestClient
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
      Bambora::ResponseAdapterFactory.for(
        super(
          path: path,
          body: Bambora::XMLRequestBody.new(body: body, response_format: RESPONSE_FORMAT).to_s,
          headers: build_headers(api_key: api_key),
        ),
      ).to_h
    end

    private

    def build_headers(api_key:)
      super(api_key: api_key, content_type: CONTENT_TYPE)
    end
  end
end
