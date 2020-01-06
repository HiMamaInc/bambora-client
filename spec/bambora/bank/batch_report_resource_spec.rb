# frozen_string_literal: true

require 'spec_helper'

module Bambora
  module Bank
    describe BatchReportResource do
      subject(:reports) { described_class.new(client: client, api_key: api_key) }

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
        instance_double(
          'Bambora::Rest::XMLClient',
          merchant_id: merchant_id,
          sub_merchant_id: sub_merchant_id,
          post: true,
        )
      end

      describe '#show' do
        let(:batch_id) { 1 }
        let(:from_date) { Time.now.to_s }
        let(:to_date) { Time.now.to_s }
        let(:service_name) { 'BatchPaymentsETF' }
        let(:filter_by) { 'batch_id' }
        let(:request_data) do
          {
            rpt_filter_by_1: filter_by,
            rpt_filter_value_1: batch_id,
            rpt_operation_type_1: 'EQ',
            rpt_from_date_time: from_date,
            rpt_to_date_time: to_date,
            service_name: service_name,
          }
        end
        let(:posted_data) do
          {
            body: {
              merchant_id: 1,
              pass_code: 'fakekey',
              rpt_filter_by_1: filter_by,
              rpt_filter_value_1: batch_id,
              rpt_format: 'JSON',
              rpt_from_date_time: from_date,
              rpt_operation_type_1: 'EQ',
              rpt_to_date_time: to_date,
              rpt_version: '2.0',
              service_name: service_name,
              session_source: 'external',
              sub_merchant_id: 2,
            },
            path: '/scripts/reporting/report.aspx',
          }
        end

        before { reports.show(request_data) }

        it 'sends `post` to the client with the correct data' do
          expect(client).to have_received(:post).with(posted_data)
        end
      end
    end
  end
end
