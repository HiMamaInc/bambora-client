# frozen_string_literal: true

require 'spec_helper'

module Bambora
  describe XMLRequestBody do
    describe '#to_s' do
      let(:hash_body) { { podlings: %w[hup kotha ydra] } }
      let(:xml_body) { "<?xml version='1.0' encoding='utf-8'?>#{Gyoku.xml(request: hash_body)}" }
      subject { described_class.new(body: hash_body).to_s }

      it 'returns xml' do
        expect(subject).to eq xml_body
      end

      context 'with a response format' do
        let(:response_format) { 'application/json' }
        let(:xml_body) do
          "<?xml version='1.0' encoding='utf-8'?>#{Gyoku.xml(request: hash_body.merge(rpt_format: response_format))}"
        end
        subject { described_class.new(body: hash_body, response_format: response_format).to_s }

        it 'uses the response format' do
          expect(subject).to eq xml_body
        end
      end
    end
  end
end
