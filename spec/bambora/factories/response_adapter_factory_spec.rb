# frozen_string_literal: true

require 'spec_helper'

module Bambora
  describe ResponseAdapterFactory do
    describe '.for' do
      let(:response) { instance_double('Faraday::Response', headers: { 'Content-Type' => content_type }) }

      subject { described_class.for(response) }

      context 'with a JSON request' do
        let(:content_type) { 'application/json; charset=utf-8' }
        it { is_expected.to be_a JSONResponse }
      end

      context 'with a Query String Response' do
        let(:content_type) { 'text/html' }
        it { is_expected.to be_a QueryStringResponse }
      end

      context 'with an unknown content type' do
        let(:content_type) { 'application/example' }
        it 'raises an error' do
          expect { subject }.to raise_error(Bambora::Client::Error, "Unknown Content Type: #{content_type}")
        end
      end
    end
  end
end
