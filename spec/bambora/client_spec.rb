# frozen_string_literal: true

require 'spec_helper'

module Bambora
  describe Client do
    describe '#profile' do
      context 'with defaults' do
        subject { Bambora::Client.new }

        it 'returns a Bambora::V1::Profile' do
          expect(subject.profiles).to be_a Bambora::V1::Profile
        end
      end

      context 'with a different version' do
        subject { Bambora::Client.new(version: 'V2') }

        it 'returns a raises an error' do
          expect { subject }.to(raise_error(Bambora::Error, 'Only V1 endpoints are supported at this time.'))
        end
      end
    end

    describe '#payments' do
      pending
    end

    describe '#batchpayments' do
      pending
    end

    describe '#batchpayment_reports' do
      pending
    end
  end
end
