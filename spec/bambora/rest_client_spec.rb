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
    end
  end
end
