# frozen_string_literal: true

module Bambora
  module Rest
    # The base class for making www form urlencoded requests.
    class WWWFormClient < Bambora::Rest::Client
      CONTENT_TYPE = 'application/x-www-form-urlencoded'

      ##
      # Make a POST Request.
      #
      # @param path [String] Indicating request path.
      # @param body [Hash] Data to be sent in the query parameters of the request.
      #
      # @return [Hash] Indicating success or failure of the operation.
      def post(path:, body:)
        # Both Faraday's and Excon's docs show that you can pass a hash into the +body+ and set the content type to
        # application/x-www-form-urlencoded and the +body+ will be transformed into query parameters, however, this
        # did not work in testing so I am manually transforming the hash into query parameters here.
        parse_response_body(
          super(
            path: path,
            body: Bambora::Builders::WWWFormParameters.new(body: body).to_s,
            headers: build_headers,
          ),
        )
      end

      private

      def build_headers
        {
          'Content-Type' => CONTENT_TYPE,
        }
      end
    end
  end
end
