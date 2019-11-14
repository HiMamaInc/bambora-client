# frozen_string_literal: true

require 'spec_helper'

module Bambora
  module Client
    module V1
      describe BatchPaymentReportResource do
        let(:api_key) { 'fakekey' }
        let(:merchant_id) { 1 }
        let(:sub_merchant_id) { 2 }
        let(:base_url) { 'https://sandbox-web.na.bambora.com' }
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
          Bambora::Client::JSONClient.new(
            base_url: base_url,
            api_key: api_key,
            merchant_id: merchant_id,
            sub_merchant_id: sub_merchant_id,
          )
        end

        subject { described_class.new(client: client, sub_path: '/scripts/reporting/report.aspx') }

        pending
      end
    end
  end
end
