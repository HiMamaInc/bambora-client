# frozen_string_literal: true

require 'spec_helper'

module Bambora
  describe JSONResponse do
    describe '#to_h' do
      context 'a valid response' do
        let(:json_response_body) { { gelflings: %w[rian deet brea] } }
        let(:faraday_response) { Faraday::Response.new(body: json_response_body.to_json.to_s) }
        subject { described_class.new(faraday_response).to_h }
        it { is_expected.to eq json_response_body }
      end

      context 'an invalid response' do
        let(:string_response_body) { 'GARTHIM! ATTACK!' }
        let(:status) { 500 }
        let(:faraday_response) { Faraday::Response.new(response_body: string_response_body, status: status) }
        let(:error_response_hash) { { status: status, body: string_response_body } }
        subject { described_class.new(faraday_response).to_h }
        it { is_expected.to eq error_response_hash }
      end
    end
  end
end
