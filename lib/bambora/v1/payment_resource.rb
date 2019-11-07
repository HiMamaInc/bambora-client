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

      # Make a payment with a credit card. Also aliased as +make_payment+.
      #
      #
      # @example
      #
      #   client = Bambora::JSONClient(base_url: '...', api_key: '...', merchant_id: '...')
      #   payments = Bambora::V1::PaymentResource(client: client)
      #   payments.create(
      #     {
      #       amount: 50,
      #       payment_method: 'card',
      #       card: {
      #         name: 'Hup Podling',
      #         number: '4504481742333',
      #         expiry_month: '12',
      #         expiry_year: '20',
      #         cvd: '123',
      #       },
      #     },
      #   )
      #
      # @param payment_data [Hash] All information relevant to making a payment.
      #
      # @see https://dev.na.bambora.com/docs/references/payment_APIs/
      #
      # @see https://dev.na.bambora.com/docs/references/payment_SDKs/take_payments/?shell#
      #
      # @return [Hash] Indicating success or failure of the operation.
      def create(payment_data)
        @client.request(method: :post, path: @sub_path, body: payment_data)
      end

      # An alias of +create+.
      alias make_payment create

      # Make a payment with a credit card. Aliased as +make_payment_with_payment_profile+.
      #
      #
      # @example
      #
      #   client = Bambora::JSONClient(base_url: '...', api_key: '...', merchant_id: '...')
      #   payments = Bambora::V1::PaymentResource(client: client)
      #   payments.create_with_payment_profile(
      #     customer_code: '2355E2e58Bf488EAB4EaFAD7083dB6A', amount: 50, complete: false
      #   )
      #
      # @param payment_data [Hash] All information relevant to making a payment.
      #
      # @return [Hash] Indicating success or failure of the operation.
      def create_with_payment_profile(customer_code:, amount:, card_id: 1, complete: false)
        create(
          amount: amount,
          payment_method: 'payment_profile',
          payment_profile: {
            customer_code: customer_code,
            card_id: card_id,
            complete: complete,
          },
        )
      end

      # An alias of =create_with_payment_profile+.
      alias make_payment_with_payment_profile create_with_payment_profile
    end
  end
end
