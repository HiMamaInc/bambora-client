# frozen_string_literal: true

module Bambora
  module V1
    class BatchPaymentReportResource
      # Summary: Statuses of batch bank-to-bank transactions.
      # Docs: https://dev.na.bambora.com/docs/guides/batch_payment/report/
      #       https://dev.na.bambora.com/docs/references/batch_payment_report/
      # Endpoint: https://na.bambora.com/scripts/reporting/report.aspx
      def initialize(client:, sub_path:)
        @client = client
        @sub_path = sub_path
      end
    end
  end
end
