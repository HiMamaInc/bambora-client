# frozen_string_literal: true

require 'spec_helper'

module Bambora
  describe Client do
    subject { described_class.new }

    describe '#initialize' do
      context 'with defaults' do
        it 'instantiates' do
          expect(subject).to be_a Bambora::Client
        end
      end

      context 'with a different version' do
        subject { described_class.new(version: 'V2') }

        it 'returns a raises an error' do
          expect { subject }.to(raise_error(Bambora::Client::Error, 'Only V1 endpoints are supported at this time.'))
        end
      end
    end

    shared_examples 'a client resource method' do |method, resource_class|
      let(:default_api_key) { 'default_api_key' }
      let(:override_api_key) { 'override_api_key' }

      context 'with an API key passed in' do
        it "returns a #{resource_class}" do
          expect(subject.public_send(method, api_key: override_api_key)).to be_a resource_class
        end

        it 'uses the API key passed in' do
          expect(subject.public_send(method, api_key: override_api_key).api_key).to eq override_api_key
        end
      end

      context 'without an API key passed in' do
        subject { described_class.new("#{method}_api_key".to_sym => default_api_key) }

        it "returns a #{resource_class}" do
          expect(subject.public_send(method)).to be_a resource_class
        end

        it 'uses the API key passed in during initialization' do
          expect(subject.public_send(method).api_key).to eq default_api_key
        end
      end
    end

    describe '#payments' do
      include_examples 'a client resource method', :payments, Bambora::V1::PaymentResource
    end

    describe '#profiles' do
      include_examples 'a client resource method', :profiles, Bambora::V1::ProfileResource
    end
  end
end
