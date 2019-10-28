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
      def initialize(client:)
        @client = client
        @sub_path = '/v1/payments'
      end

      def make_payment(payment_data)
        @client.request(method: :post, path: @sub_path, body: payment_data)
      end

      def make_payment_with_payment_profile(customer_code:, amount:)
        @client.request(
          method: :post,
          path: @sub_path,
          body: {
            amount: amount,
            payment_method: 'payment_profile',
            payment_profile: {
              customer_code: customer_code,
              card_id: 1,
            },
          },
        )
      end
    end
  end
end
