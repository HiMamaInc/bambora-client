# frozen_string_literal: true

require 'spec_helper'

module Bambora
  module Builders
    describe XMLRequestBody do
      describe '#to_s' do
        let(:hash_body) { { podlings: %w[hup kotha ydra] } }
        let(:xml_body) { "<?xml version='1.0' encoding='utf-8'?>#{Gyoku.xml(request: hash_body)}" }
        subject { described_class.new(body: hash_body).to_s }

        it 'returns xml' do
          expect(subject).to eq xml_body
        end
      end
    end
  end
end
