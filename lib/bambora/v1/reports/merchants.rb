# frozen_string_literal: true

module Bambora
  module V1
    module Reports
      class Merchants
        def self.get_all(options = {})
          credentials = options[:credentials]

          Bambora::Rest::JSONClient
            .new(base_url: 'https://api.na.bambora.com', merchant_id: credentials.merchant_id)
            .get(path: '/v1/reports/merchants', api_key: credentials.reporting_passcode)
        end
      end
    end
  end
end
