# frozen_string_literal: true

require 'spec_helper'

module Bambora
  module V1
    describe Profile do
      let(:api_key) { 'fakekey' }
      let(:merchant_id) { 1 }
      let(:sub_merchant_id) { 2 }
      let(:headers) { { 'Authorization' => 'Passcode MTpmYWtla2V5', 'Sub-Merchant-ID' => sub_merchant_id } }
      let(:response_body) do
        {
          code: 1,
          message: 'Operation Successful',
          customer_code: '02355E2e58Bf488EAB4EaFAD7083dB6A',
        }
      end

      subject { Bambora::Client.new(api_key: api_key, merchant_id: merchant_id, sub_merchant_id: sub_merchant_id) }

      describe '#create' do
        before do
          stub_request(:post, "#{subject.base_url}/v1/profiles").with(
            body: data.to_json.to_s,
            headers: headers,
          ).to_return(body: response_body.to_json.to_s)
        end

        let(:data) do
          {
            language: 'en',
            comments: 'hup!',
            card: {
              name: 'Hup Podling',
              number: '4030000010001234',
              expiry_month: '12',
              expiry_year: '23',
              cvd: '123',
            },
          }
        end

        it 'posts to the Bambora API' do
          subject.profiles.create(data)

          expect(
            a_request(:post, "#{subject.base_url}/v1/profiles").with(
              body: data.to_json.to_s,
              headers: headers,
            ),
          ).to have_been_made.once
        end
      end

      describe '#delete' do
        before do
          stub_request(:delete, "#{subject.base_url}/v1/profiles/#{customer_code}")
            .to_return(body: response_body.to_json.to_s)
        end

        let(:customer_code) { '02355E2e58Bf488EAB4EaFAD7083dB6A' }

        it 'posts to the Bambora API' do
          subject.profiles.delete(customer_code: customer_code)

          expect(
            a_request(:delete, "#{subject.base_url}/v1/profiles/#{customer_code}").with(
              headers: headers,
            ),
          ).to have_been_made.once
        end
      end
    end
  end
end
