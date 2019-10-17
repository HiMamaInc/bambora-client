# frozen_string_literal: true

require 'spec_helper'

describe Bambora::Profile do
  let(:api_key) { 'fakekey' }
  let(:merchant_id) { 1 }
  let(:base_url) { 'https://sandbox-api.na.bambora.com' }

  subject { Bambora::Client.new(api_key: api_key, merchant_id: merchant_id) }

  before { allow(ENV).to receive(:fetch).with('BAMBORA_API_URL').and_return(base_url) }

  describe '#create' do
    before { stub_request(:post, "#{base_url}/v1/profiles") }

    it 'posts to the bambora api' do
      subject.profile.create({})
      expect(a_request(:post, "#{base_url}/v1/profiles")).to have_been_made.once
    end
  end

  describe '#delete' do
    let(:id) { 1 }
    before { stub_request(:delete, "#{base_url}/v1/profiles/#{id}") }

    it 'posts to the bambora api' do
      subject.profile.delete(1)
      expect(a_request(:delete, "#{base_url}/v1/profiles/#{id}")).to have_been_made.once
    end
  end
end
