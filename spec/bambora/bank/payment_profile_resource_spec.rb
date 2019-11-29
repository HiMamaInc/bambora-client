# frozen_string_literal: true

require 'spec_helper'

module Bambora
  module Bank
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
        let(:account_holder) { 'All-Maudra Mayrin' }
        let(:name) { 'Brea Princess of Vapra' }
        let(:email_address) { 'brea@theresistance.com' }
        let(:phone_number) { '1231231234' }
        let(:address_1) { 'The Castle' }
        let(:city) { "Ha'rar" }
        let(:postal_code) { 'H0H 0H0' }
        let(:province) { 'Vapra' }
        let(:country) { 'Thra' }
        let(:profile_data) do
          {
            customer_code: '1234',
            bank_account_type: 'CA',
            account_holder: account_holder,
            institution_number: '123',
            branch_number: '12345',
            account_number: '123456789',
            name: name,
            email_address: email_address,
            phone_number: phone_number,
            address_1: address_1,
            city: city,
            postal_code: postal_code,
            province: province,
            country: country,
            sub_merchant_id: sub_merchant_id,
            operation_type: 'N',
          }
        end

        let(:query_params) do
          {
            'accountHolder' => account_holder,
            'accountNumber' => '123456789',
            'bankAccountType' => 'CA',
            'branchNumber' => '12345',
            'customerCode' => '1234',
            'institutionNumber' => '123',
            'merchantId' => merchant_id,
            'operationType' => 'N',
            'ordAddress1' => address_1,
            'ordCity' => city,
            'ordCountry' => country,
            'ordEmailAddress' => email_address,
            'ordName' => name,
            'ordPhoneNumber' => phone_number,
            'ordPostalCode' => postal_code,
            'ordProvince' => province,
            'passCode' => api_key,
            'serviceVersion' => '1.0',
            'subMerchantId' => sub_merchant_id,
          }
        end

        let(:response_body) do
          'customerCode=1eCe9480a7D94919997071a483505D17&responseCode=1&responseMessage=Operation+Successful&'\
            "status=A&ordName=#{name}&ordAddress1=#{address_1}&ordAddress2=&ordCity=#{city}&ordProvince=#{province}"\
            "&ordCountry=#{country}&ordPostalCode=#{postal_code}&ordEmailAddress=#{email_address}&"\
            "ordPhoneNumber=#{phone_number}&customerLanguage=en&accountRef="
        end

        let(:response_body_hash) do
          {
            customer_code: '1eCe9480a7D94919997071a483505D17',
            response_code: '1',
            response_message: 'Operation Successful',
            status: 'A',
            name: name,
            address_1: address_1,
            address_2: '',
            city: city,
            province: province,
            country: country,
            postal_code: postal_code,
            email_address: email_address,
            phone_number: phone_number,
            customer_language: 'en',
            account_ref: '',
          }
        end

        before do
          stub_request(:post, "#{base_url}/scripts/payment_profiles.asp").with(
            query: query_params,
            headers: headers,
          ).to_return(headers: response_headers, body: response_body)
        end

        it "POST's to the Bambora API" do
          resp = subject.create(profile_data)
          expect(resp).to eq response_body_hash

          expect(
            a_request(:post, "#{base_url}/scripts/payment_profiles.asp").with(
              query: query_params,
              headers: headers,
            ),
          ).to have_been_made.once
        end
      end
    end
  end
end
