# frozen_string_literal: true

require 'spec_helper'

module Bambora
  module V1
    describe ProfileResource do
      let(:api_key) { 'fakekey' }
      let(:merchant_id) { 1 }
      let(:sub_merchant_id) { 2 }
      let(:base_url) { 'https://sandbox-api.na.bambora.com' }
      let(:headers) { { 'Authorization' => 'Passcode MTpmYWtla2V5', 'Sub-Merchant-ID' => sub_merchant_id } }
      let(:response_headers) { { 'Content-Type' => 'application/json' } }
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
        Bambora::Rest::JSONClient.new(
          base_url: base_url,
          merchant_id: merchant_id,
          sub_merchant_id: sub_merchant_id,
        )
      end

      subject { Bambora::V1::ProfileResource.new(client: client, api_key: api_key) }

      describe '#create' do
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

        before do
          stub_request(:post, "#{base_url}/v1/profiles").with(
            body: data.to_json.to_s,
            headers: headers,
          ).to_return(headers: response_headers, body: response_body.to_json.to_s)
        end

        it 'posts to the bambora api' do
          subject.create(data)

          expect(
            a_request(:post, "#{base_url}/v1/profiles").with(
              body: data.to_json.to_s,
              headers: headers,
            ),
          ).to have_been_made.once
        end
      end

      describe '#get' do
        before do
          stub_request(:get, "#{base_url}/v1/profiles/#{customer_code}")
            .with(headers: headers)
            .to_return(headers: response_headers, body: response_body.to_json.to_s)
        end

        let(:customer_code) { 'asdf1234' }
        let(:headers) { { 'Authorization' => 'Passcode MTpmYWtla2V5' } }
        let(:response_body) do
          {
            code: 1,
            card: {},
            billing: {},
          }
        end

        it 'performs GET request for profile data' do
          subject.get(customer_code: customer_code)

          expect(
            a_request(:get, "#{base_url}/v1/profiles/#{customer_code}")
              .with(headers: headers),
          ).to have_been_made.once
        end
      end

      describe '#update' do
        let(:customer_code) { 'asdf1234' }
        let(:headers) { { 'Authorization' => 'Passcode MTpmYWtla2V5' } }
        let(:data) do
          {
            card: {
              name: 'Hup Podling',
              number: '4030000010001234',
              expiry_month: '12',
              expiry_year: '23',
              cvd: '123',
            },
            billing: {
              name: 'john doe',
              address_line1: '123 main st',
              address_line2: '111',
              city: 'victoria',
              province: 'bc',
              country: 'ca',
              postal_code: 'V8T4M3',
              phone_number: '25012312345',
              email_address: 'bill@smith.com',
            },
          }
        end

        let(:response_body) do
          {
            code: 1,
            card: {},
            billing: {},
          }
        end

        before do
          stub_request(:put, "#{base_url}/v1/profiles/#{customer_code}").with(
            body: data.to_json.to_s,
            headers: headers,
          ).to_return(headers: response_headers, body: response_body.to_json.to_s)
        end

        it 'posts to the bambora api' do
          subject.update(customer_code: customer_code, payment_profile_data: data)

          expect(
            a_request(:put, "#{base_url}/v1/profiles/#{customer_code}").with(
              body: data.to_json.to_s,
              headers: headers,
            ),
          ).to have_been_made.once
        end
      end

      describe '#delete' do
        let(:customer_code) { 'asdf1234' }

        before do
          stub_request(:delete, "#{base_url}/v1/profiles/#{customer_code}")
            .with(headers: headers)
            .to_return(headers: response_headers, body: response_body.to_json.to_s)
        end

        it 'posts to the bambora api' do
          subject.delete(customer_code: customer_code)

          expect(
            a_request(:delete, "#{base_url}/v1/profiles/#{customer_code}").with(
              headers: headers,
            ),
          ).to have_been_made.once
        end
      end
    end
  end
end
