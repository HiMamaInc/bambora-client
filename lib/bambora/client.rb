# frozen_string_literal: true

# Standard Libraries
require 'base64'
require 'cgi'
require 'csv'
require 'json'

# Gems
require 'faraday' # HTTP Wraper
require 'gyoku' # XML Builder
require 'multiparty' # Multipart/mixed requests

require 'bambora/client/version'

# Adapters
require 'bambora/adapters/response'
require 'bambora/adapters/json_response'
require 'bambora/adapters/multipart_mixed_request'
require 'bambora/adapters/query_string_response'
require 'bambora/bank/adapters/payment_profile_response'

# Builders
require 'bambora/builders/headers'
require 'bambora/builders/xml_request_body'
require 'bambora/builders/www_form_parameters'
require 'bambora/builders/batch_payment_csv'
require 'bambora/bank/builders/payment_profile_params'

# Factories
require 'bambora/factories/response_adapter_factory'

# Clients
require 'bambora/rest/client'
require 'bambora/rest/batch_payment_file_upload_client'
require 'bambora/rest/json_client'
require 'bambora/rest/www_form_client'
require 'bambora/rest/xml_client'

# Resources
require 'bambora/v1/batch_payment_resource'
require 'bambora/v1/payment_resource'
require 'bambora/v1/profile_resource'
require 'bambora/bank/payment_profile_resource'
require 'bambora/bank/batch_report_messages'
require 'bambora/bank/batch_report_resource'

module Bambora
  ##
  # The Client class is used to initialize Resource objects that can make requests to the Bambora API.
  class Client
    class Error < StandardError; end

    attr_reader :base_url, :merchant_id, :scripts_api_base_url, :sub_merchant_id

    # Initialze a new Bambora::Client.
    #
    # @example
    #
    #   client = Bambora::Client.new do |c|
    #     c.base_url = ENV.fetch('BAMBORA_BASE_URL')
    #     c.scripts_api_base_url = ENV.fetch('BAMBORA_SCRIPTS_BASE_URL')
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
    # @param api_key [String] API key for the profiles endpoint.
    #
    # @return [Bambora::V1::ProfileResource]
    def profiles(api_key:)
      @profiles ||= Bambora::V1::ProfileResource.new(client: json_client, api_key: api_key)
    end

    # Retrieve a client to make requests to the Payments endpoints.
    #
    # @example
    #   payments = client.profiles(api_key: <yourapikey>)
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
    # @param api_key [String] API key for the payments endpoint.
    #
    # @return [Bambora::V1::PaymentResource]
    def payments(api_key:)
      @payments ||= Bambora::V1::PaymentResource.new(client: json_client, api_key: api_key)
    end

    # Retrieve a client to make requests to the Bank Payment Profiles endpoints.
    #
    # @example
    #   profiles = client.bank_profiles(api_key: <yourapikey>)
    #
    #   data = {
    #     customer_code: '1234',
    #     bank_account_type: 'CA',
    #     bank_account_holder: 'All-Maudra Mayrin',
    #     institution_number: '123',
    #     branch_number: '12345',
    #     account_number: '123456789',
    #     name: 'Brea Princess of Vapra',
    #     email_address: 'brea@theresistance.com',
    #     phone_number: '1231231234',
    #     address_1: 'The Castle',
    #     city: "Ha'rar",
    #     postal_code: 'H0H 0H0',
    #     province: 'Vapra',
    #     country: 'Thra',
    #     sub_merchant_id: 1,
    #   }
    #
    #   profiles.create(data)
    #
    # @param api_key [String] API key for the bank profiles endpoint.
    #
    # @return [Bambora::Bank::PaymentProfileResource]
    def bank_profiles(api_key:)
      @bank_profiles ||= Bambora::Bank::PaymentProfileResource.new(client: www_form_client, api_key: api_key)
    end

    # Retrieve a client to make requests to the batch report endpoint.
    #
    # @example
    #   batch_reports = client.batch_reports(api_key: <yourapikey>)
    #
    #   data = {
    #     rpt_filter_by_1: 'batch_id',
    #     rpt_filter_value_1: 1,
    #     rpt_operation_type_1: 'EQ',
    #     rpt_from_date_time: '2019-12-18 00:00:00',
    #     rpt_to_date_time: '2019-12-18 23:59:59',
    #     service_name: 'BatchPaymentsEFT',
    #   }
    #
    #   batch_reports.show(data)
    #
    # @param api_key [String] API key for the bank profiles endpoint.
    #
    # @return [Bambora::Bank::PaymentProfileResource]
    def batch_reports(api_key:)
      @batch_reports = Bambora::Bank::BatchReportResource.new(
        client: xml_client,
        api_key: api_key,
      )
    end

    def batch_payments(api_key:)
      @batch_payments ||= Bambora::V1::BatchPaymentResource.new(
        client: batch_payment_file_upload_client,
        api_key: api_key,
      )
    end

    private

    def json_client
      @json_client ||= Bambora::Rest::JSONClient.new(
        base_url: base_url,
        merchant_id: merchant_id,
        sub_merchant_id: sub_merchant_id,
      )
    end

    def www_form_client
      @www_form_client ||= Bambora::Rest::WWWFormClient.new(
        base_url: scripts_api_base_url,
        merchant_id: merchant_id,
        sub_merchant_id: sub_merchant_id,
      )
    end

    def batch_payment_file_upload_client
      @batch_payment_file_upload_client ||= Bambora::Rest::BatchPaymentFileUploadClient.new(
        base_url: base_url,
        merchant_id: merchant_id,
        sub_merchant_id: sub_merchant_id,
      )
    end

    def xml_client
      @xml_client ||= Bambora::Rest::XMLClient.new(
        base_url: scripts_api_base_url,
        merchant_id: merchant_id,
        sub_merchant_id: sub_merchant_id,
      )
    end
  end
end
