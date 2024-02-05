# frozen_string_literal: true

module Bambora
  ##
  # Parses a query string response into a Hash
  class QueryStringResponse < Response
    def to_h
      parsed_response = super
      return error_response if parsed_response.values.flatten.empty? # We didn't get a query string back.

      parsed_response.transform_values { |val| val.length == 1 ? val.first : val }
    end

    private

    def parser
      CGI
    end
  end
end
