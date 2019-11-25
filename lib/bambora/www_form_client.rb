# frozen_string_literal: true

module Bambora
  # The base class for making www form urlencoded requests.
  class WWWFormClient < Bambora::RestClient
    CONTENT_TYPE = 'application/x-www-form-urlencoded'

    ##
    # Make a POST Request.
    #
    # @param path [String] Indicating request path.
    # @param body [Hash] Data to be sent in the query parameters of the request.
    # @param api_key [String] Indicating the API Key to be used with the request.
    #
    # @return [Hash] Indicating success or failure of the operation.
    def post(path:, body:, api_key:)
      parse_response_body(
        super(
          path: "#{path}?#{WWWFormParameters.new(body: body)}",
          body: nil,
          headers: build_headers(api_key: api_key),
        ),
      )
    end

    private

    def build_headers(api_key:)
      super(api_key: api_key, content_type: CONTENT_TYPE)
    end
  end
end
