# frozen_string_literal: true

require 'spec_helper'

describe Bambora::Profile do
  let(:api_key) { 'fakekey' }
  let(:merchant_id) { 1 }
  let(:base_url) { 'https://sandbox-api.na.bambora.com' }
  let(:headers) { { 'Authorization' => 'Passcode MTpmYWtla2V5' } }

  subject { Bambora::Client.new(api_key: api_key, merchant_id: merchant_id) }

  before { allow(ENV).to receive(:fetch).with('BAMBORA_API_URL').and_return(base_url) }

  describe '#create' do
    before { stub_request(:post, "#{base_url}/v1/profiles") }
    let(:data) do
      {
        language: 'en',
        comments: 'hello',
        card: {
          name: 'Jane Fonda',
          number: '4030000010001234',
          expiry_month: '12',
          expiry_year: '23',
          cvd: '123',
        },
      }
    end

    it 'posts to the bambora api' do
      subject.profile.create(data)
      expect(
        a_request(:post, "#{base_url}/v1/profiles").with(
          body: data.to_json.to_s,
          headers: headers,
        ),
      ).to have_been_made.once
    end
  end

  describe '#delete' do
    let(:id) { 1 }
    before { stub_request(:delete, "#{base_url}/v1/profiles/#{id}") }

    it 'posts to the bambora api' do
      subject.profile.delete(1)
      expect(
        a_request(:delete, "#{base_url}/v1/profiles/#{id}").with(
          headers: headers,
        ),
      ).to have_been_made.once
    end
  end
end
