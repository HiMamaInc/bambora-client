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

      # Return payment.
      #
      # @example
      #
      #   client = Bambora::Rest::JSONClient(base_url: '...', api_key: '...', merchant_id: '...')
      #   payments = Bambora::V1::PaymentResource(client: client)
      #   payments.return_payment(
      #     transaction_id: 1000341, amount: 50
      #   )
      #
      # @param transaction_id [Integer] The transaction id
      # @param amount [Float] A decimal value in dollars. Must be less than or equal to the original purchase amount.
      # @param order_number [String] (Optional) A unique order number.
      #
      # @return [Hash] Indicating success or failure of the operation.
      def return_payment(transaction_id:, amount:, order_number: nil)
        data = { amount: amount, order_number: order_number }.compact
        client.post(path: "#{sub_path}/#{transaction_id}/returns", body: data, api_key: api_key)
      end

      # Void a transaction. You can void payments, returns, pre-auths, and completions. It will
      # cancel that transaction.
      #
      # @example
      #
      #   client = Bambora::Rest::JSONClient(base_url: '...', api_key: '...', merchant_id: '...')
      #   payments = Bambora::V1::PaymentResource(client: client)
      #   payments.void_payment(
      #     transaction_id: 1000341, amount: 50
      #   )
      #
      # @param transaction_id [Integer] The transaction id to void.
      # @param amount [Float] A decimal value in dollars. Must be equal to the original purchase amount. You can void purchases as well as pre-auths and returns.
      # @param order_number [String] (Optional) A unique order number.
      #
      # @return [Hash] Indicating success or failure of the operation.
      def void(transaction_id:, amount:, order_number: nil)
        data = { amount: amount, order_number: order_number }.compact
        client.post(path: "#{sub_path}/#{transaction_id}/void", body: data, api_key: api_key)
      end

      alias void_payment void

      # Complete a pre-authorized payment. The amount of the transaction to complete must be less
      # than or equal to the original pre-auth amount.
      #
      # @example
      #
      #   client = Bambora::Rest::JSONClient(base_url: '...', api_key: '...', merchant_id: '...')
      #   payments = Bambora::V1::PaymentResource(client: client)
      #   payments.complete_preauth(
      #     transaction_id: 1000341, amount: 50
      #   )
      #
      # @param transaction_id [Integer] An integer identifier for the associated transaction.
      # @param amount [Float] A decimal value in dollars. Uses up to two decimal places. Max value is account specific.
      #   Default max value is 1000.
      # @param order_number [String] (Optional) A unique order number.
      #
      # @return [Hash] Indicating success or failure of the operation.
      def complete_preauth(transaction_id:, amount:, order_number: nil)
        data = { amount: amount, order_number: order_number }.compact
        client.post(path: "#{sub_path}/#{transaction_id}/completions", body: data, api_key: api_key)
      end

      # Retrieve the details of a previously attempted payment.
      #
      #
      # @example
      #
      #   client = Bambora::Rest::JSONClient(base_url: '...', api_key: '...', merchant_id: '...')
      #   payments = Bambora::V1::PaymentResource(client: client)
      #   payments.get(transaction_id: 1000341)
      #
      # @param transaction_id [Integer] An integer identifier for the associated transaction.
      #
      # @return [Hash] Transaction details.
      def get(transaction_id:)
        client.get(path: "#{sub_path}/#{transaction_id}", api_key: api_key)
      end
    end
  end
end
