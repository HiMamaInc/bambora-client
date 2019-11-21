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
    end

    describe '#payments' do
      include_examples 'a client resource method', :payments, Bambora::V1::PaymentResource
    end

    describe '#profiles' do
      include_examples 'a client resource method', :profiles, Bambora::V1::ProfileResource
    end
  end
end
