# frozen_string_literal: true

module Bambora
  module V1
    class PaymentResource
      attr_reader :api_key, :client, :sub_path

      def initialize(client:, api_key:)
        @client = client
        @api_key = api_key
        @sub_path = '/v1/payments'
      end

      # Make a payment with a credit card. Also aliased as +make_payment+.
      #
      #
      # @example
      #
      #   client = Bambora::Rest::JSONClient(base_url: '...', api_key: '...', merchant_id: '...')
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
        client.post(path: sub_path, body: payment_data, api_key: api_key)
      end

      alias make_payment create

      # Make a payment with a credit card. Aliased as +make_payment_with_payment_profile+.
      #
      #
      # @example
      #
      #   client = Bambora::Rest::JSONClient(base_url: '...', api_key: '...', merchant_id: '...')
      #   payments = Bambora::V1::PaymentResource(client: client)
      #   payments.create_with_payment_profile(
      #     customer_code: '2355E2e58Bf488EAB4EaFAD7083dB6A', amount: 50, complete: false
      #   )
      #
      # @param customer_code [String] Bambora's payment profile ID.
      # @param amount [Float] A decimal value in dollars. Uses up to two decimal places. Max value is account specific.
      #   Default max value is 1000.
      # @param card_id [Integer] Default +1+. Which credit card to use. Starts at 1 for the first card. You must
      #   configure how many cards can be stored by visiting the profile options in the back office.
      # @param complete [Boolean] Default +false+. Set to false for Pre-Authorize, and true to complete a payment.
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

      alias make_payment_with_payment_profile create_with_payment_profile

      # Retrieve the details of a previously attempted payment.
      #
      #
      # @example
      #
      #   client = Bambora::Rest::JSONClient(base_url: '...', api_key: '...', merchant_id: '...')
      #   payments = Bambora::V1::PaymentResource(client: client)
      #   payments.get(transaction_id: 1000341)
      #
      # @param transaction_id [Integer] An integeridentifier for the associated transaction.
      #
      # @return [Hash] Transaction details.
      def get(transaction_id:)
        client.get(path: "#{sub_path}/#{transaction_id}", api_key: api_key)
      end
    end
  end
end
