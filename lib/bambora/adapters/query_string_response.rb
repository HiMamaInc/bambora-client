# frozen_string_literal: true

module Bambora
  ##
  # Parses a JSON response into a Hash
  class QueryStringResponse < Response
    def to_h
      parsed_response = super
      return error_response if parsed_response.values.flatten.empty? # We didn't get a query string back.

      parsed_response
    end

    private

    def parser
      CGI
    end
  end
end
