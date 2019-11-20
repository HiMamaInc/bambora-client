# frozen_string_literal: true

require 'spec_helper'

module Bambora
  describe XMLClient do
    let(:api_key) { 'fakekey' }
    let(:merchant_id) { 1 }
    let(:base_url) { 'https://sandbox-api.na.bambora.com' }
    let(:headers) do
      {
        'Content-Type' => 'application/xml',
        'Authorization' => 'Passcode MTpmYWtla2V5',
      }
    end
    let(:path) { '/' }
    let(:response_body) { { response: 'body', with: { objects: 'yay!' }, and: [{ arrays: 'wow!' }] } }
    let(:xml_response_body) { Gyoku.xml(response_body) }
    let(:failed_status) { 500 }
    let(:failed_response_body) { 'Mouldy mildew, mother of mouthmuck, dangle and strangle and death.' }

    subject { described_class.new(base_url: base_url, merchant_id: merchant_id) }

    describe '#post' do
      let(:request_body) { { gelfling: 'Deet' } }
      let(:xml_request_body) { Gyoku.xml(request: xml_request_body) }

      context 'server responds with a 2xx status' do
        before do
          stub_request(:post, base_url)
            .with(headers: headers, body: xml_request_body)
            .to_return(body: response_body.to_json.to_s)
        end

        it 'parses the response' do
          resp = subject.post(path: path, body: request_body, api_key: api_key)
          expect(resp).to eq response_body
        end
      end

      context 'server responds with a non 2xx status' do
        let(:response_body) { 'Mouldy mildew, mother of mouthmuck, dangle and strangle and death.' }

        before do
          stub_request(:post, base_url)
            .with(headers: headers, body: xml_request_body)
            .to_return(body: failed_response_body, status: failed_status)
        end

        it 'it returns a hash' do
          resp = subject.post(path: path, body: request_body, api_key: api_key)
          expect(resp).to eq(status: failed_status, body: failed_response_body)
        end
      end
    end
  end
end
