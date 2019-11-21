# frozen_string_literal: true

require 'spec_helper'

module Bambora
  describe XMLRequestBody do
    describe '.build' do
      let(:hash_body) { { podlings: %w[hup kotha ydra] } }
      let(:xml_body) { Gyoku.xml(request: hash_body) }
      subject { described_class.build(body: hash_body) }

      it 'returns xml' do
        expect(subject).to eq xml_body
      end

      context 'with a response format' do
        let(:response_format) { 'application/json' }
        let(:xml_body) { Gyoku.xml(request: hash_body.merge(rpt_format: response_format)) }
        subject { described_class.build(body: hash_body, response_format: response_format) }

        it 'uses the response format' do
          expect(subject).to eq xml_body
        end
      end
    end
  end
end
