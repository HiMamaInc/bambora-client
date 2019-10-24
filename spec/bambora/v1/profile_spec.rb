# frozen_string_literal: true

require 'spec_helper'

module Bambora
  module V1
    describe Profile do
      let(:api_key) { 'fakekey' }
      let(:merchant_id) { 1 }
      let(:sub_merchant_id) { 2 }
      let(:base_url) { 'https://api.na.bambora.com' }
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

      subject { Bambora::Client.new(api_key: api_key, merchant_id: merchant_id, sub_merchant_id: sub_merchant_id) }

      before { allow(ENV).to receive(:fetch).with('BAMBORA_API_URL').and_return(base_url) }

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
          ).to_return(body: response_body.to_json.to_s)
        end

        it 'posts to the bambora api' do
          subject.profile.create(data)
          expect(
            a_request(:post, "#{base_url}/v1/profiles").with(
              body: data.to_json.to_s,
              headers: headers,
            ),
          ).to have_been_made.once
        end
      end

      describe '#delete' do
        let(:customer_code) { 'asdf1234' }
        before do
          stub_request(:delete, "#{base_url}/v1/profiles/#{customer_code}").to_return(body: response_body.to_json.to_s)
        end

        it 'posts to the bambora api' do
          subject.profile.delete(customer_code: customer_code)
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
