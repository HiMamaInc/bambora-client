# frozen_string_literal: true

module Bambora
  module Builders
    ##
    # Builds WWW URL Encoded request parameters from a Hash
    class WWWFormParameters
      attr_reader :body

      ##
      # Initiallze a new WWWFormParameter
      #
      # @params body [Hash]
      def initialize(body:)
        @body = body
      end

      ##
      # Convert a hash to url-encoded query parameters.
      #
      # @return [String]
      def to_s
        URI.encode_www_form(sanitized_body)
      end

      private

      def sanitized_body
        body.reject { |_, val| val.to_s.empty? }
      end
    end
  end
end
