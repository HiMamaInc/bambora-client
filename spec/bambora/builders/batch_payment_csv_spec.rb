# frozen_string_literal: true

require 'spec_helper'

module Bambora
  module Builders
    describe BatchPaymentCSV do
      describe '#build' do
        let(:transactions) do
          [
            {
              super_type: 'E',
              transaction_type: 'D',
              institution_number: 12_345,
              transit_number: 123,
              account_number: 123_456_789,
              amount: 10_000,
              reference_nubmer: 1234,
              reccipient_name: 'Hup Podling',
              customer_code: '02355E2e58Bf488EAB4EaFAD7083dB6A',
              dynamic_description: 'The Skeksis',
            },
          ]
        end

        let(:csv_string) do
          "E,D,12345,123,123456789,10000,1234,Hup Podling,02355E2e58Bf488EAB4EaFAD7083dB6A,The Skeksis\r\n"
        end

        it 'generates a CSV with CRLF line endings' do
          expect(described_class.build(transactions)).to eq csv_string
        end
      end
    end
  end
end
