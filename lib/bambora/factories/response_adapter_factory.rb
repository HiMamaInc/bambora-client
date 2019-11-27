# frozen_string_literal: true

module Bambora
  ##
  # Selects an adapter for parsing an HTTP response body
  class ResponseAdapterFactory
    class << self
      def for(response)
        content_type = response.headers['Content-Type']
        case content_type
          when 'application/json' then Bambora::JSONResponse.new(response)
          when 'text/html' then Bambora::QueryStringResponse.new(response)
          else raise Bambora::Client::Error, "Unknown Content Type: #{content_type}"
        end
      end
    end
  end
end
