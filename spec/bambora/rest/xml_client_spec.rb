# frozen_string_literal: true

require 'spec_helper'

module Bambora
  module Rest
    describe XMLClient do
      subject(:client) { described_class.new(base_url: base_url, merchant_id: merchant_id) }

      let(:api_key) { 'fakekey' }
      let(:merchant_id) { 1 }
      let(:base_url) { 'https://sandbox-api.na.bambora.com' }
      let(:headers) { { 'Content-Type' => 'application/xml' } }
      let(:path) { '/' }
      let(:connection) { instance_double('Faraday::Connection') }

      before { allow(Faraday).to receive(:new).and_return(connection) }

      describe '#post' do
        let(:request_body) { { gelfling: 'Deet' } }
        let(:xml_request_body) do
          "<?xml version='1.0' encoding='utf-8'?>#{Gyoku.xml(request: request_body)}"
        end
        let(:response_headers) { { 'Content-Type' => 'application/json' } }
        let(:response_body) { { response: 'body', with: { objects: 'yay!' }, and: [{ arrays: 'wow!' }] } }
        let(:response) do
          instance_double('Faraday::Response', headers: response_headers, body: response_body.to_json.to_s)
        end

        context 'server responds with a 2xx status' do
          before do
            allow(connection).to(receive(:post).with(path, xml_request_body, headers).and_return(response))
          end

          it 'parses the response' do
            resp = subject.post(path: path, body: request_body)
            expect(resp).to eq response_body
          end
        end

        context 'server responds with a non 2xx status' do
          let(:failed_response_body) { 'Mouldy mildew, mother of mouthmuck, dangle and strangle and death.' }
          let(:response_headers) { { 'Content-Type' => 'text/html' } }
          let(:failed_status) { 500 }
          let(:response) do
            instance_double(
              'Faraday::Response',
              headers: response_headers,
              status: failed_status,
              body: failed_response_body,
            )
          end

          before do
            allow(connection).to(receive(:post).with(path, xml_request_body, headers).and_return(response))
          end

          it 'it returns a hash' do
            resp = subject.post(path: path, body: request_body)
            expect(resp).to eq(status: failed_status, body: failed_response_body)
          end
        end
      end
    end
  end
end
