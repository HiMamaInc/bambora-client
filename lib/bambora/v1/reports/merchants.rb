# frozen_string_literal: true

module Bambora
  module V1
    module Reports
      class Merchants
        def self.get(merchant_id, options = {})
          credentials = options[:credentials]

          raise ArgumentError, "#{self}.get takes an integer argument" unless merchant_id.is_a?(Integer)

          response =
            Bambora::Rest::JSONClient
              .new(base_url: 'https://api.na.bambora.com', merchant_id: credentials.merchant_id)
              .get(path: "/v1/reports/merchants/#{merchant_id}", api_key: credentials.reporting_passcode)

          raise InvalidAuthenticationError, response if response[:message] == 'Authentication failed'

          raise InvalidRequestError, response if response == { Message: 'The request is invalid.' }

          response
        end

        def self.get_all(options = {})
          credentials = options[:credentials]

          response =
            Bambora::Rest::JSONClient
              .new(base_url: 'https://api.na.bambora.com', merchant_id: credentials.merchant_id)
              .get(path: '/v1/reports/merchants', api_key: credentials.reporting_passcode)

          raise InvalidAuthenticationError, response if response[:message] == 'Authentication failed'

          response
        end
      end
    end
  end
end
