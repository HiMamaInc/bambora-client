# frozen_string_literal: true

module Bambora
  module V1
    class BatchPaymentResource
      # Summary: Bank Electronic Funds Transfer (CAD) and Automatic Clearing House (USD)
      # Docs: https://dev.na.bambora.com/docs/guides/batch_payment/
      #       https://dev.na.bambora.com/docs/references/batch_payment/
      # Endpoint: https://api.na.bambora.com/v1/batchpayments
      def initialize(client:, sub_path:)
        @client = client
        @sub_path = sub_path
      end
    end
  end
end
