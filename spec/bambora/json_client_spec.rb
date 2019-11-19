# frozen_string_literal: true

require 'spec_helper'

module Bambora
  describe JSONClient do
    let(:api_key) { 'fakekey' }
    let(:merchant_id) { 1 }
    let(:base_url) { 'https://sandbox-api.na.bambora.com' }
    let(:headers) { { 'Authorization' => 'Passcode MTpmYWtla2V5' } }
    let(:path) { '/' }
    let(:response_body) { { response: 'body', with: { objects: 'yay!' }, and: [{ arrays: 'wow!' }] } }
    let(:failed_status) { 500 }
    let(:failed_response_body) { 'Mouldy mildew, mother of mouthmuck, dangle and strangle and death.' }

    subject { described_class.new(base_url: base_url, merchant_id: merchant_id) }

    describe '#get' do
      context 'server responds with a 2xx status' do
        before do
          stub_request(:get, base_url).with(headers: headers).to_return(body: response_body.to_json.to_s)
        end

        it 'parses the response' do
          resp = subject.get(path: path, api_key: api_key)
          expect(resp).to eq response_body
        end
      end

      context 'server responds with a non 2xx status' do
        before do
          stub_request(:get, base_url)
            .with(headers: headers)
            .to_return(body: failed_response_body, status: failed_status)
        end

        it 'it returns a hash' do
          resp = subject.get(path: path, api_key: api_key)
          expect(resp).to eq(status: failed_status, body: failed_response_body)
        end
      end
    end

    describe '#post' do
      let(:request_body) { { gelfling: 'Deet' } }

      context 'server responds with a 2xx status' do
        before do
          stub_request(:post, base_url)
            .with(headers: headers, body: request_body)
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
            .with(headers: headers, body: request_body)
            .to_return(body: failed_response_body, status: failed_status)
        end

        it 'it returns a hash' do
          resp = subject.post(path: path, body: request_body, api_key: api_key)
          expect(resp).to eq(status: failed_status, body: failed_response_body)
        end
      end
    end

    describe '#delete' do
      context 'server responds with a 2xx status' do
        before do
          stub_request(:delete, base_url).with(headers: headers).to_return(body: response_body.to_json.to_s)
        end

        it 'parses the response' do
          resp = subject.delete(path: path, api_key: api_key)
          expect(resp).to eq response_body
        end
      end

      context 'server responds with a non 2xx status' do
        before do
          stub_request(:delete, base_url)
            .with(headers: headers)
            .to_return(body: failed_response_body, status: failed_status)
        end

        it 'it returns a hash' do
          resp = subject.delete(path: path, api_key: api_key)
          expect(resp).to eq(status: failed_status, body: failed_response_body)
        end
      end
    end
  end
end
