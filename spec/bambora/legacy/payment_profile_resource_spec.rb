# frozen_string_literal: true

require 'spec_helper'

module Bambora
  module Legacy
    describe PaymentProfileResource do
      let(:api_key) { 'fakekey' }
      let(:merchant_id) { 1 }
      let(:sub_merchant_id) { 1 }
      let(:base_url) { 'https://sandbox-api.na.bambora.com' }
      let(:headers) { { 'Content-Type' => 'application/x-www-form-urlencoded' } }
      let(:response_headers) { { 'Content-Type' => 'text/html' } }
      let(:client) do
        Bambora::WWWFormClient.new(base_url: base_url, merchant_id: merchant_id, sub_merchant_id: sub_merchant_id)
      end

      subject { described_class.new(client: client, api_key: api_key) }

      describe '#create' do
        let(:profile_data) do
          {
            customer_code: '1234',
            bank_account_type: 'CA',
            account_holder: 'All-Maudra Mayrin',
            institution_number: '123',
            branch_number: '12345',
            account_number: '123456789',
            name: 'Hup Podling',
            email_address: 'Brea Princess of Vapra',
            phone_number: '1231231234',
            address_1: 'The Castle',
            city: "Ha'rar",
            postal_code: 'H0H 0H0',
            province: 'Vapra',
            country: 'Thra',
            sub_merchant_id: sub_merchant_id,
            operation_type: 'N',
          }
        end

        let(:query_params) do
          {
            'customerCode' => '1234',
            'bankAccountType' => 'CA',
            'accountHolder' => 'All-Maudra Mayrin',
            'institutionNumber' => '123',
            'branchNumber' => '12345',
            'accountNumber' => '123456789',
            'ordName' => 'Hup Podling',
            'ordEmailAddress' => 'Brea Princess of Vapra',
            'ordPhoneNumber' => '1231231234',
            'ordAddress1' => 'The Castle',
            'ordCity' => "Ha'rar",
            'ordPostalCode' => 'H0H 0H0',
            'ordProvince' => 'Vapra',
            'ordCountry' => 'Thra',
            'passCode' => api_key,
            'merchantId' => merchant_id,
            'subMerchantId' => sub_merchant_id,
            'serviceVersion' => '1.0',
            'operationType' => 'N',
          }
        end

        let(:encoded_query_params) { URI.encode_www_form(query_params) }

        let(:response_body) { '' }

        before do
          stub_request(:post, "#{base_url}/scripts/payment_profiles.asp?#{encoded_query_params}").with(
            headers: headers,
          ).to_return(headers: response_headers, body: response_body)
        end

        it "POST's to the Bambora API" do
          subject.create(profile_data)

          expect(
            a_request(:post, "#{base_url}/scripts/payment_profiles.asp?#{encoded_query_params}").with(
              headers: headers,
            ),
          ).to have_been_made.once
        end
      end
    end
  end
end
