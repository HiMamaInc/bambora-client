# frozen_string_literal: true

require 'spec_helper'

module Bambora
  describe Headers do
    describe '.build' do
      let(:sekret) { 'sekret' }
      subject { described_class.build(api_key: sekret, merchant_id: 1) }
      it { is_expected.to eq('Authorization' => 'Passcode MTpzZWtyZXQ=') }

      context 'with a sub_merchant_id' do
        let(:id) { 1 }
        subject { described_class.build(api_key: sekret, merchant_id: 1, sub_merchant_id: id) }
        it { is_expected.to eq('Authorization' => 'Passcode MTpzZWtyZXQ=', 'Sub-Merchant-Id' => id) }
      end

      context 'with a content_type' do
        let(:content_type) { 'applicaiton/json' }
        subject { described_class.build(api_key: sekret, merchant_id: 1, content_type: content_type) }
        it { is_expected.to eq('Authorization' => 'Passcode MTpzZWtyZXQ=', 'Content-Type' => content_type) }
      end
    end
  end
end
