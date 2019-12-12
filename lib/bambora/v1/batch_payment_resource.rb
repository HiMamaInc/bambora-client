# frozen_string_literal: true

module Bambora
  module V1
    # Summary: Bank Electronic Funds Transfer (CAD) and Automatic Clearing House (USD)
    # Docs: https://dev.na.bambora.com/docs/guides/batch_payment/
    #       https://dev.na.bambora.com/docs/references/batch_payment/
    # Endpoint: https://api.na.bambora.com/v1/batchpayments
    class BatchPaymentResource
      attr_reader :client, :api_key, :sub_path

      def initialize(client:, api_key:)
        @client = client
        @api_key = api_key
        @sub_path = '/v1/batchpayments'
      end

      ##
      # @see https://dev.na.bambora.com/docs/references/batch_payment/
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
      def create(transactions, opts = { process_now: true })
        client.post(
          path: sub_path,
          file_contents: csv_string(transactions),
          options: opts,
          api_key: api_key,
        )
      end

      private

      def csv_string(transactions)
        Bambora::Builders::BatchPaymentCSV.build(transactions)
      end
    end
  end
end
