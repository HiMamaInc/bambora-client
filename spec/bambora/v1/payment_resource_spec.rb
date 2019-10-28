# frozen_string_literal: true

require 'spec_helper'

module Bambora
  module V1
    describe PaymentResource do
      let(:api_key) { 'fakekey' }
      let(:merchant_id) { 1 }
      let(:sub_merchant_id) { 2 }
      let(:base_url) { 'https://sandbox-api.na.bambora.com' }
      let(:headers) { { 'Authorization' => 'Passcode MTpmYWtla2V5', 'Sub-Merchant-ID' => sub_merchant_id } }
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
        Bambora::JSONClient.new(
          base_url: base_url,
          api_key: api_key,
          merchant_id: merchant_id,
          sub_merchant_id: sub_merchant_id,
        )
      end

      subject { described_class.new(client: client) }

      describe '#make_payment' do
        before(:each) do
          stub_request(:post, "#{base_url}/v1/payments").with(
            body: data.to_json.to_s,
            headers: headers,
          ).to_return(body: response_body.to_json.to_s)
        end

        let(:data) do
          {
            amount: 50,
            payment_method: 'card',
            card: {
              name: 'Hup Podling',
              number: '4030000010001234',
              expiry_month: '12',
              expiry_year: '23',
              cvd: '123',
            },
          }
        end

        it "POST's to the Bambora API" do
          subject.make_payment(data)

          expect(
            a_request(:post, "#{base_url}/v1/payments").with(
              body: data.to_json.to_s,
              headers: headers,
            ),
          ).to have_been_made.once
        end
      end

      describe '#make_payment_with_payment_profile' do
        before(:each) do
          stub_request(:post, "#{base_url}/v1/payments").with(
            body: data.to_json.to_s,
            headers: headers,
          ).to_return(body: response_body.to_json.to_s)
        end

        let(:customer_code) { '02355E2e58Bf488EAB4EaFAD7083dB6A' }
        let(:data) do
          {
            amount: 50,
            payment_method: 'payment_profile',
            payment_profile: {
              customer_code: customer_code,
              card_id: 1,
            },
          }
        end

        it "POST's to the Bambora API" do
          subject.make_payment_with_payment_profile(customer_code: customer_code, amount: 50)

          expect(
            a_request(:post, "#{base_url}/v1/payments").with(
              body: data.to_json.to_s,
              headers: headers,
            ),
          ).to have_been_made.once
        end
      end
    end
  end
end
