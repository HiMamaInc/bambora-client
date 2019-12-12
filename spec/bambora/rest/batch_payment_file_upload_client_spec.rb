# frozen_string_literal: true

require 'spec_helper'

module Bambora
  module Rest
    describe BatchPaymentFileUploadClient do
      subject(:client) do
        described_class.new(base_url: base_url, merchant_id: merchant_id, sub_merchant_id: sub_merchant_id)
      end

      let(:merchant_id) { 1 }
      let(:sub_merchant_id) { 2 }
      let(:base_url) { 'https://sandbox-api.na.bambora.com' }
      let(:api_key) { 'fakekey' }
      let(:csv_content) do
        <<~CSV
          E,C,001,99001,09400313371,10000,1000070001,ACME Corp
          E,C,002,99002,09400313372,20000,1000070002,John Doe
          E,C,003,99003,09400313373,30000,1000070003,Jane Doe
        CSV
      end
      let(:options) { { process_now: 1 } }
      let(:response_headers) { { 'Content-Type' => 'application/json' } }
      let(:response_body) do
        {
          code: 1,
          message: 'File successfully received',
          batch_id: '100',
          process_date: Date.today.to_s,
          process_time_zone: 'GMT-08:00',
          batch_mode: 'live',
        }
      end

      let(:request_body) do
        <<~BODY
					--multiparty-boundary-50428029
					Content-Disposition: form-data; name='criteria'; name="criteria"
					Content-Type: application/json

					{"process_now":1}
					--multiparty-boundary-50428029
					Content-Disposition: form-data; name="data"; filename="merchant_2.txt"
					Content-Type: text/plain
					Content-Transfer-Encoding: binary

					E,C,001,99001,09400313371,10000,1000070001,ACME Corp
					E,C,002,99002,09400313372,20000,1000070002,John Doe
					E,C,003,99003,09400313373,30000,1000070003,Jane Doe

					--multiparty-boundary-50428029--
        BODY
      end

      let(:multipart_mixed_request_class) do
        class_double('Bambora::Adapters::MultipartMixedRequest').as_stubbed_const(transfer_nested_constants: true)
      end

      let(:multipart_double) do
        instance_double(
          'Bambora::Adapters::MultipartMixedRequest',
          body: request_body,
          content_type: 'multipart/form-data; boundary=multiparty-boundary-50428029',
        )
      end

      let(:multipart_args) do
        {
          multipart_args: {
            criteria: {
              content_disposition: "form-data; name='criteria'",
              content_type: 'application/json',
              content: options.to_json,
            },
            data: {
              filename: "merchant_#{sub_merchant_id}.txt",
              content_type: 'text/plain',
              content: csv_content,
            },
          },
        }
      end

      describe '#create' do
        context 'server responds with a 2xx status' do
          before do
            allow(multipart_mixed_request_class).to receive(:new).with(multipart_args).and_return(multipart_double)
            # WebMock does not support verifying the body with a regex on a multi-part form request.
            stub_request(:post, base_url).with(
              headers: {
                'Authorization' => 'Passcode MTpmYWtla2V5',
              },
            ).to_return(headers: response_headers, body: response_body.to_json.to_s)
          end

          it 'parses the response' do
            resp = client.post(file_contents: csv_content, options: options, api_key: api_key)
            expect(resp).to eq response_body
          end

          it 'sends the correct parameters to MultipartMixedRequest' do
            client.post(file_contents: csv_content, options: options, api_key: api_key)
            expect(multipart_mixed_request_class).to have_received(:new).with(multipart_args)
          end
        end

        context 'server responds with a non 2xx status' do
          let(:failed_status) { 500 }
          let(:failed_response_body) { 'Mouldy mildew, mother of mouthmuck, dangle and strangle and death.' }

          before do
            stub_request(:post, base_url).with(
              headers: {
                'Authorization' => 'Passcode MTpmYWtla2V5',
              },
            ).to_return(headers: response_headers, body: failed_response_body, status: failed_status)
          end

          it 'parses the response' do
            resp = client.post(file_contents: csv_content, options: options, api_key: api_key)
            expect(resp).to eq(status: failed_status, body: failed_response_body)
          end
        end
      end
    end
  end
end
