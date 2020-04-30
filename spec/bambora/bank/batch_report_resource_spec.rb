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
          response: {
            version: '1.0',
            code: 1,
            message: 'Report generated',
            records: {
              total: 3,
            },
            record: [
              {
                rowId: 1,
                merchantId: 300_202_779,
                batchId: 10_000_000,
                transId: 1,
                itemNumber: 1,
                payeeName: 'General Motors',
                reference: '1000070001',
                operationType: 'C',
                amount: 10_000,
                stateId: 2,
                stateName: 'Scheduled',
                statusId: 1,
                statusName: 'Validated/Approved',
                bankDescriptor: '',
                messageId: '',
                customerCode: '',
                settlementDate: '2017-08-09',
                returnedDate: '',
                returnType: '',
                eftId: 0,
              },
            ],
          },
        }
      end

      let(:expected_response) do
        {
          response: {
            version: '1.0',
            code: 1,
            message: 'Report generated',
            records: {
              total: 3,
            },
            record: [
              {
                rowId: 1,
                merchantId: 300_202_779,
                batchId: 10_000_000,
                transId: 1,
                itemNumber: 1,
                payeeName: 'General Motors',
                reference: '1000070001',
                operationType: 'C',
                amount: 10_000,
                stateId: 2,
                stateName: 'Scheduled',
                statusId: 1,
                statusName: 'Validated/Approved',
                bankDescriptor: '',
                messageId: '',
                messages: [],
                customerCode: '',
                settlementDate: '2017-08-09',
                returnedDate: '',
                returnType: '',
                eftId: 0,
              },
            ],
          },
        }
      end

      let(:client) do
        instance_double(
          'Bambora::Rest::XMLClient',
          merchant_id: merchant_id,
          sub_merchant_id: sub_merchant_id,
          post: response_body,
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

        context 'with no messageId' do
          it 'sends `post` to the client with the correct data' do
            reports.show(request_data)
            expect(client).to have_received(:post).with(posted_data)
          end

          it 'returns the expected response' do
            expect(reports.show(request_data)).to eq expected_response
          end
        end

        context 'with messageIds' do
          let(:response_body) do
            {
              response: {
                version: '1.0',
                code: 1,
                message: 'Report generated',
                records: {
                  total: 3,
                },
                record: [
                  {
                    rowId: 1,
                    merchantId: 300_202_779,
                    batchId: 10_000_000,
                    transId: 1,
                    itemNumber: 1,
                    payeeName: 'General Motors',
                    reference: '1000070001',
                    operationType: 'C',
                    amount: 10_000,
                    stateId: 2,
                    stateName: 'Scheduled',
                    statusId: 1,
                    statusName: 'Validated/Approved',
                    bankDescriptor: '',
                    messageId: '1,2',
                    customerCode: '',
                    settlementDate: '2017-08-09',
                    returnedDate: '',
                    returnType: '',
                    eftId: 0,
                  },
                ],
              },
            }
          end

          let(:expected_response) do
            {
              response: {
                version: '1.0',
                code: 1,
                message: 'Report generated',
                records: {
                  total: 3,
                },
                record: [
                  {
                    rowId: 1,
                    merchantId: 300_202_779,
                    batchId: 10_000_000,
                    transId: 1,
                    itemNumber: 1,
                    payeeName: 'General Motors',
                    reference: '1000070001',
                    operationType: 'C',
                    amount: 10_000,
                    stateId: 2,
                    stateName: 'Scheduled',
                    statusId: 1,
                    statusName: 'Validated/Approved',
                    bankDescriptor: '',
                    messageId: '1,2',
                    messages: ['Invalid bank number', 'Invalid branch number'],
                    customerCode: '',
                    settlementDate: '2017-08-09',
                    returnedDate: '',
                    returnType: '',
                    eftId: 0,
                  },
                ],
              },
            }
          end

          it 'returns the expected response' do
            expect(reports.show(request_data)).to eq expected_response
          end
        end

        context 'with nil record' do
          let(:response_body) do
            {
              response: {
                version: '1.0',
                code: 1,
                message: 'Report generated',
                records: {
                  total: 0,
                },
              },
            }
          end

          let(:expected_response) do
            {
              response: {
                version: '1.0',
                code: 1,
                message: 'Report generated',
                records: {
                  total: 0,
                },
                record: [],
              },
            }
          end

          it 'ensures return contains an :record key' do
            expect(reports.show(request_data)).to eq expected_response
          end
        end
      end
    end
  end
end
