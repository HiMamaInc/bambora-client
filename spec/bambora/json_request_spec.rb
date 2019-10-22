# frozen_string_literal: true

require 'spec_helper'

module Bambora
  describe JSONRequest do
    let(:api_key) { 'fakekey' }
    let(:merchant_id) { 1 }
    let(:base_url) { 'https://sandbox-api.na.bambora.com' }
    let(:headers) { { 'Authorization' => 'Passcode MTpmYWtla2V5' } }
    let(:response_body) { { response: 'body', with: { objects: 'yay!' }, and: [{ arrays: 'wow!' }] } }
    let(:client) { Bambora::Client.new(api_key: api_key, merchant_id: merchant_id) }

    subject { Bambora::JSONRequest.new(client) }

    before { allow(ENV).to receive(:fetch).with('BAMBORA_API_URL').and_return(base_url) }

    describe '#request' do
      context 'server responds with a 2xx status' do
        before do
          stub_request(:get, base_url).with(headers: headers).to_return(body: response_body.to_json.to_s)
        end

        it 'parses the response' do
          resp = subject.request(method: :get, path: '/')
          expect(resp).to eq response_body
        end
      end

      context 'server responds with a non 2xx status' do
        let(:status) { 500 }
        let(:body) { 'Mouldy mildew, mother of mouthmuck, dangle and strangle and death.' }

        before do
          stub_request(:get, base_url).with(headers: headers).to_return(body: body, status: status)
        end

        it 'raises an error' do
          resp = subject.request(method: :get, path: '/')
          expect(resp).to eq(status: status, body: body)
        end
      end
    end
  end
end
