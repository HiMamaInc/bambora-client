# frozen_string_literal: true

require 'base64'
require 'faraday'
require 'gyoku'
require 'nori'
require 'bambora/client/version'
require 'bambora/headers'
require 'bambora/xml_request_body'
require 'bambora/json_response'
require 'bambora/rest_client'
require 'bambora/json_client'
require 'bambora/xml_client'
require 'bambora/v1/batch_payment_report_resource'
require 'bambora/v1/batch_payment_resource'
require 'bambora/v1/payment_resource'
require 'bambora/v1/profile_resource'

module Bambora
  class Client
    class Error < StandardError; end
    class ServerError < StandardError; end

    attr_accessor :base_url, :merchant_id, :sub_merchant_id

    # Initialze a new Bambora::Client.
    #
    # @example
    #
    #   client = Bambora::Client.new do |c|
    #     c.base_url = ENV.fetch('BAMBORA_BASE_URL')
    #     c.merchant_id = ENV.fetch('BAMBORA_MERCHANT_ID')
    #     c.sub_merchant_id = ENV.fetch('BAMBORA_SUB_MERCHANT_ID')
    #   end
    #
    # @param options[base_url] [String] Bambora Base URL
    # @param options[merchant_id] [String] The Merchant ID for this request.
    # @param options[sub_merchant_id] [String] The Sub-Merchant ID for this request.
    def initialize(options = {})
      if !options[:version].nil? && options[:version].upcase != 'V1'
        raise Bambora::Client::Error, 'Only V1 endpoints are supported at this time.'
      end

      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end

      yield(self) if block_given?
    end

    # Retrieve a client to make requests to the Profiles endpoints.
    #
    # @example
    #   profiles = client.profiles
    #   profiles.delete(customer_code: '02355E2e58Bf488EAB4EaFAD7083dB6A')
    #
    # @param api_key [String] optional API key for the profiles endpoint. If the Client class was initialized with an
    #   API key, this parameter is not needed.
    #
    # @return [Bambora::V1::ProfileResource]
    def profiles(api_key:)
      @profiles ||= Bambora::V1::ProfileResource.new(client: json_client, api_key: api_key)
    end

    # Retrieve a client to make requests to the Payments endpoints.
    #
    # @example
    #   payments = client.profiles
    #   payments.create(
    #     {
    #       amount: 50,
    #       payment_method: 'card',
    #       card: {
    #         name: 'Hup Podling',
    #         number: '4504481742333',
    #         expiry_month: '12',
    #         expiry_year: '20',
    #         cvd: '123',
    #       },
    #     },
    #   )
    #
    # @param api_key [String] optional API key for the payments endpoint. If the Client class was initialized with an
    #   API key, this parameter is not needed.
    #
    # @return [Bambora::V1::PaymentResource]
    def payments(api_key:)
      @payments ||= Bambora::V1::PaymentResource.new(client: json_client, api_key: api_key)
    end

    def batch_payment_reports; end

    def batch_payments; end

    private

    def json_client
      @json_client ||= Bambora::JSONClient.new(
        base_url: base_url,
        merchant_id: merchant_id,
        sub_merchant_id: sub_merchant_id,
      )
    end
  end
end
