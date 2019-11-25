# frozen_string_literal: true

require 'spec_helper'

module Bambora
  describe WWWFormClient do
    let(:merchant_id) { 1 }
    let(:base_url) { 'https://sandbox-api.na.bambora.com' }
    let(:headers) do
      {
        'Content-Type' => 'application/x-www-form-urlencoded',
      }
    end
    let(:path) { '/' }
    let(:response_body) { { response: 'body' } }
    let(:query_string_response_body) { URI.encode_www_form(response_body) }
    let(:failed_status) { 500 }
    let(:failed_response_body) { 'Stupid Garthim! You want Gelfling? Why not ask me?!' }

    subject { described_class.new(base_url: base_url, merchant_id: merchant_id) }

    describe '#post' do
      let(:request_body) { { gelfling: 'Deet' } }

      context 'server responds with a 2xx status' do
        before do
          stub_request(:post, base_url)
            .with(headers: headers, query: request_body)
            .to_return(headers: { 'Content-Type' => 'text/html' }, body: query_string_response_body)
        end

        it 'parses the response' do
          resp = subject.post(path: path, body: request_body)
          expect(resp).to eq response_body
        end
      end

      context 'server responds with a non 2xx status' do
        let(:response_body) { 'Mouldy mildew, mother of mouthmuck, dangle and strangle and death.' }

        before do
          stub_request(:post, base_url)
            .with(headers: headers, query: request_body)
            .to_return(
              headers: { 'Content-Type' => 'text/html' },
              body: failed_response_body,
              status: failed_status,
            )
        end

        it 'it returns a hash' do
          resp = subject.post(path: path, body: request_body)
          expect(resp).to eq(status: failed_status, body: failed_response_body)
        end
      end
    end
  end
end
