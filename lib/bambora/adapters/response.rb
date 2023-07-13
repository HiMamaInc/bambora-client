# frozen_string_literal: true

module Bambora
  ##
  # Parses a response into a Hash. Uses JSON to parse by default.
  class Response
    DEFAULT_PARSER = JSON

    attr_reader :response

    def initialize(response)
      @response = response
    end

    def to_h
      deep_transform_keys_in_object(parser.parse(response.body.to_s), &:to_sym)
    rescue JSON::ParserError
      error_response
    end

    private

    def deep_transform_keys_in_object(object, &block)
      case object
        when Hash
          object.each_with_object({}) do |(key, value), result|
            result[yield(key)] = deep_transform_keys_in_object(value, &block)
          end
        when Array
          object.map { |e| deep_transform_keys_in_object(e, &block) }
        else
          object
      end
    end

    # Faraday 1.0 fixed a bug where request/response bodies were indistinguishable.
    # Our tests rely on this behaviour, and perhaps upstream clients do too.
    # @SEE https://github.com/lostisland/faraday/pull/847
    def error_response
      {
        status: response.status,
        body: response.body || response.env.request_body,
      }
    end

    def parser
      DEFAULT_PARSER
    end
  end
end
