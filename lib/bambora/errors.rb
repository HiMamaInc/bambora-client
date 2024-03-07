# frozen_string_literal: true

module Bambora
  # All library-specific errors inherit from this error class. This helps make it easy for integrations to rescue
  # specifically from errors raised by this library.
  class Error < StandardError
    attr_reader :payload

    def initialize(message = nil, payload = {})
      @message = message
      @payload = payload

      super(
        <<~ERROR
          #{@message}

            #{JSON.pretty_generate(@payload).gsub("\n", "\n  ")}
        ERROR
      )
    end
  end

  # An error returned when the API returns an authentication failure.
  class InvalidAuthenticationError < Error
    def initialize(payload = {})
      super(nil, payload)
    end
  end

  # An error returned when the API returns an invalid request.
  class InvalidRequestError < Error
    def initialize(payload = {})
      super(nil, payload)
    end
  end
end
