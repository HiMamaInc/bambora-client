# frozen_string_literal: true

module Bambora
  module Builders
    class BatchPaymentCSV
      class << self
        ##
        # Return a CSV with one transaction per row.
        #
        # @see https://dev.na.bambora.com/docs/references/batch_payment/
        #
        # @example
        #   Bambora::Builders::BatchPaymentCSV.build([{
        #     super_type: 'E',
        #     transaction_type: 'D',
        #     institution_number: 12345,
        #     transit_number: 123,
        #     account_number: 1223456789,
        #     amount: 10000
        #     reference_nubmer: 1234,
        #     recipient_name: 'Hup Podling',
        #     customer_code: '02355E2e58Bf488EAB4EaFAD7083dB6A',
        #     dynamic_description: 'The Skeksis',
        #   }])
        #
        #   # => "E,D,12345,123,123456789,10000,1234,Hup Podling,02355E2e58Bf488EAB4EaFAD7083dB6A,The Skeksis\n"
        #
        # @param transactions [Array] an array of transaciton hashes.
        #
        # @return [String], a CSV as a string
        def build(transactions)
          CSV.generate do |csv|
            transactions.each do |transaction|
              csv << transaction.values
            end
          end
        end
      end
    end
  end
end
