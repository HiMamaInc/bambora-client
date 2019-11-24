# frozen_string_literal: true

module Bambora
  ##
  # Builds WWW URL Encoded request parameters from a Hash
  class WWWFormParameters
    attr_reader :body, :response_format

    def initialize(body:)
      @body = body
    end

    def to_s
      URI.encode_www_form(body)
    end
  end
end
