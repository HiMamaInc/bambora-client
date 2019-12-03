# frozen_string_literal: true

require 'spec_helper'

module Bambora
  module Rest
    describe Client do
      describe '#initialize' do
        context 'with defaults' do
          subject { described_class.new }

          it 'instantiates' do
            expect(subject).to be_a Bambora::Rest::Client
          end
        end
      end
    end
  end
end
