# frozen_string_literal: true

require 'spec_helper'

module Bambora
  module V1
    describe BatchPaymentResource do
      let(:api_key) { 'fakekey' }
      let(:merchant_id) { 1 }
      let(:sub_merchant_id) { 2 }
      let(:base_url) { 'https://sandbox-api.na.bambora.com' }
      let(:headers) { { 'Authorization' => 'Passcode MTpmYWtla2V5', 'Sub-Merchant-ID' => sub_merchant_id } }

      let(:transactions) do
        [
          {
            super_type: 'E',
            transaction_type: 'D',
            institution_number: 12_345,
            transit_number: 123,
            account_number: 1_223_456_789,
            amount: 10_000,
            reference_nubmer: 1234,
            reccipient_name: 'Hup Podling',
            customer_code: '02355E2e58Bf488EAB4EaFAD7083dB6A',
            dynamic_description: 'The Skeksis',
          },
        ]
      end

      let(:file_contents) do
        "E,D,12345,123,1223456789,10000,1234,Hup Podling,02355E2e58Bf488EAB4EaFAD7083dB6A,The Skeksis\r\n"
      end

      let(:client) do
        instance_double(
          'Bambora::Rest::BatchPaymentFileUploadClient',
          base_url: base_url,
          merchant_id: merchant_id,
          sub_merchant_id: sub_merchant_id,
        )
      end

      subject(:resource) { described_class.new(client: client, api_key: api_key) }

      describe '#create' do
        before do
        end

        it 'sends post to the client' do
          expect(client).to receive(:post).with(
            path: '/v1/batchpayments',
            file_contents: file_contents,
            options: { process_now: 1, sub_merchant_id: client.sub_merchant_id },
            api_key: api_key,
          )
          resource.create(transactions)
        end
      end
    end
  end
end
