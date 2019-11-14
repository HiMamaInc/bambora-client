# frozen_string_literal: true

require 'spec_helper'

module Bambora
  describe RestClient do
    describe '#initialize' do
      context 'with defaults' do
        subject { described_class.new }

        it 'instantiates' do
          expect(subject).to be_a Bambora::RestClient
        end
      end

      context 'with a different version' do
        subject { described_class.new(version: 'V2') }

        it 'returns a raises an error' do
          expect { subject }.to(raise_error(Bambora::Client::Error, 'Only V1 endpoints are supported at this time.'))
        end
      end
    end
  end
end
