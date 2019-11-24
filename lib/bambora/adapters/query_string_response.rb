# frozen_string_literal: true

module Bambora
  ##
  # Parses a JSON response into a Hash
  class QueryStringResponse < Response
    def to_h
      parsed_response = super
      return error_response if parsed_response.values.flatten.empty? # We didn't get a query string back.

      parsed_response.each_with_object({}) { |(key, val), obj| obj[key] = val.length == 1 ? val.first : val }
    end

    private

    def parser
      CGI
    end
  end
end
