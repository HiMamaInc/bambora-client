# frozen_string_literal: true

module Bambora
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
      URI.encode_www_form(body)
    end
  end
end
