# frozen_string_literal: true

require 'spec_helper'

module Bambora
  module Bank
    module Builders
      describe PaymentProfileParams do
        describe '.build' do
          let(:original_hash) do
            {
              customer_code: '1234',
              bank_account_type: 'CA',
              bank_account_holder: 'All-Maudra Mayrin',
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
              pass_code: 'aba121',
              merchant_id: 1,
              service_version: '1.0',
            }
          end

          let(:expected_hash) do
            {
              'customerCode' => '1234',
              'bankAccountType' => 'CA',
              'bankAccountHolder' => 'All-Maudra Mayrin',
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
              'passCode' => 'aba121',
              'merchantId' => 1,
              'serviceVersion' => '1.0',
            }
          end

          subject { described_class.build(original_hash) }

          it { is_expected.to eq expected_hash }
        end
      end
    end
  end
end
