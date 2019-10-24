# frozen_string_literal: true

module Bambora
  module V1
    class PaymentResource
      # Summary: Create and modify payments.
      # Note: The link below links to all apis includding profiles and tokenization. There aren't great docs explaining
      #       the /payments endpoints alone.
      # Docs: https://dev.na.bambora.com/docs/references/payment_APIs/
      #       https://dev.na.bambora.com/docs/references/payment_SDKs/take_payments/?shell#
      # Endpoint: https://api.na.bambora.com/v1/payments
      def initialize(client:, sub_path:)
        @client = client
        @sub_path = sub_path
      end
    end
  end
end
