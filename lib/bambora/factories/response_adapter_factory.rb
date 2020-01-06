# frozen_string_literal: true

module Bambora
  ##
  # Selects an adapter for parsing an HTTP response body
  class ResponseAdapterFactory
    class << self
      def for(response)
        content_type = response.headers['Content-Type'].split(';').first
        case content_type
          when 'application/json'
            Bambora::JSONResponse.new(response)
          when 'text/html'
            # Currently, the only endpoint that responds wit text/html is /scripts/payment_profiles.asp
            Bambora::Bank::Adapters::PaymentProfileResponse.new(response)
          else raise Bambora::Client::Error, "Unknown Content Type: #{content_type}. Response Body: #{response.body}"
        end
      end
    end
  end
end
