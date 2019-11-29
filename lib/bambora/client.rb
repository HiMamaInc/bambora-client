# frozen_string_literal: true

# Libraries
require 'base64'
require 'json'
require 'cgi'
require 'faraday'
require 'gyoku'

require 'bambora/client/version'

# Builders
require 'bambora/headers'
require 'bambora/xml_request_body'
require 'bambora/www_form_parameters'
require 'bambora/bank/builders/payment_profile_params'

# Factories
require 'bambora/factories/response_adapter_factory'

# Adapters
require 'bambora/adapters/response'
require 'bambora/adapters/json_response'
require 'bambora/adapters/query_string_response'
require 'bambora/bank/adapters/payment_profile_response'

# Clients
require 'bambora/rest_client'
require 'bambora/json_client'
require 'bambora/xml_client'
require 'bambora/www_form_client'

# Resources
require 'bambora/v1/batch_payment_report_resource'
require 'bambora/v1/batch_payment_resource'
require 'bambora/v1/payment_resource'
require 'bambora/v1/profile_resource'
require 'bambora/bank/payment_profile_resource'

module Bambora
  ##
  # The Client class is used to initialize Resource objects that can make requests to the Bambora API.
  class Client
    class Error < StandardError; end

    attr_reader :base_url, :merchant_id, :sub_merchant_id

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
    # @param api_key [String] optional API key for the payments endpoint.
    #
    # @return [Bambora::V1::PaymentResource]
    def payments(api_key:)
      @payments ||= Bambora::V1::PaymentResource.new(client: json_client, api_key: api_key)
    end

    # Retrieve a client to make requests to the Bank Payment Profiles endpoints.
    #
    # @example
    #   profiles = client.bank_profiles
    #
    #   data = {
    #     customer_code: '1234',
    #     bank_account_type: 'CA',
    #     account_holder: account_holder,
    #     institution_number: '123',
    #     branch_number: '12345',
    #     account_number: '123456789',
    #     name: name,
    #     email_address: email_address,
    #     phone_number: phone_number,
    #     address_1: address_1,
    #     city: city,
    #     postal_code: postal_code,
    #     province: province,
    #     country: country,
    #     sub_merchant_id: sub_merchant_id,
    #     operation_type: 'N',
    #   }
    #
    #   profiles.create(data)
    #
    # @param api_key [String] optional API key for the bank profiles endpoint.
    #
    # @return [Bambora::Bank::PaymentProfileResource]
    def bank_profiles(api_key:)
      @bank_profiles ||= Bambora::Bank::PaymentProfileResource.new(client: www_form_client, api_key: api_key)
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

    def www_form_client
      @www_form_client ||= Bambora::WWWFormClient.new(
        base_url: base_url,
        merchant_id: merchant_id,
        sub_merchant_id: sub_merchant_id,
      )
    end
  end
end
