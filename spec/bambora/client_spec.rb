# frozen_string_literal: true

require 'spec_helper'

module Bambora
  describe Client do
    describe '#initialize' do
      context 'with defaults' do
        subject { Bambora::Client.new }

        it 'instantiates' do
          expect(subject).to be_a Bambora::Client
        end
      end

      context 'with a different version' do
        subject { Bambora::Client.new(version: 'V2') }

        it 'returns a raises an error' do
          expect { subject }.to(raise_error(Bambora::Error, 'Only V1 endpoints are supported at this time.'))
        end
      end
    end
  end
end
