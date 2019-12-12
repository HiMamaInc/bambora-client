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
      let(:response_headers) { { 'Content-Type' => 'application/json' } }
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
      let(:response_body) do
        {
          code: 1,
          message: 'Hup...want...buy.',
          customer_code: 'aaa111',
          validation: {
            id: '',
            approved: 1,
            message_id: 1,
            message: '',
            auth_code: '',
            trans_date: '',
            order_number: '',
            type: '',
            amount: 0,
            cvd_id: 123,
          },
        }
      end

      let(:client) do
        Bambora::Rest::BatchPaymentFileUploadClient.new(
          base_url: base_url,
          merchant_id: merchant_id,
          sub_merchant_id: sub_merchant_id,
        )
      end

      subject(:resource) { described_class.new(client: client, api_key: api_key) }

      describe '#create' do
        before do
          stub_request(:post, "#{base_url}/v1/batchpayments")
            .with(headers: headers)
            .to_return(headers: response_headers, body: response_body.to_json.to_s)
        end

        it 'POSTs to the Bambora API' do
          resource.create(transactions)

          expect(
            a_request(:post, "#{base_url}/v1/batchpayments").with(
              headers: headers,
            ),
          ).to have_been_made.once
        end
      end
    end
  end
end
