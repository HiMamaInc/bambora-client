# frozen_string_literal: true

require 'spec_helper'

describe Bambora::Headers do
  describe '.build' do
    let(:sekret) { 'sekret' }
    subject { described_class.build(passcode: sekret) }
    it { is_expected.to eq('Authorization' => "Passcode #{sekret}") }

    context 'with a sub_merchant_id' do
      let(:id) { 1 }
      subject { described_class.build(passcode: sekret, sub_merchant_id: id) }
      it { is_expected.to eq('Authorization' => "Passcode #{sekret}", 'Sub-Merchant-Id' => id) }
    end
  end
end
