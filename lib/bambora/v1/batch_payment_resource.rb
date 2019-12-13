# frozen_string_literal: true

module Bambora
  module V1
    # Bank Electronic Funds Transfer (CAD) and Automatic Clearing House (USD)
    class BatchPaymentResource
      attr_reader :client, :api_key, :sub_path

      def initialize(client:, api_key:)
        @client = client
        @api_key = api_key
        @sub_path = '/v1/batchpayments'
      end

      ##
      # Post batch payment data.
      #
      # @example
      #   batch_payment_resource.create(
      #     [{
      #       super_type: 'E',
      #       transaction_type: 'D',
      #       institution_number: 12345,
      #       transit_number: 123,
      #       account_number: 1223456789,
      #       amount: 10000,
      #       reference_nubmer: 1234,
      #       reccipient_name: 'Hup Podling',
      #       customer_code: '02355E2e58Bf488EAB4EaFAD7083dB6A',
      #       dynamic_description: 'The Skeksis',
      #     }],
      #   )
      #
      # @param transactions [Array] of hashes with payment data.
      # @param opts[:process_now] [Integer] optional. Defaults to 1.
      # @param opts[:process_date] [String] optional. Must also set process_now to 0.
      #
      # @see https://dev.na.bambora.com/docs/references/batch_payment/
      # @see https://dev.na.bambora.com/docs/guides/batch_payment/
      def create(transactions, opts = { process_now: 1 })
        client.post(
          path: sub_path,
          file_contents: Bambora::Builders::BatchPaymentCSV.build(transactions),
          options: opts.merge(sub_merchant_id: client.sub_merchant_id),
          api_key: api_key,
        )
      end
    end
  end
end
