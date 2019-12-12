# frozen_string_literal: true

module Bambora
  module Bank
    ##
    # For making requests to the /scripts/payment_profile.asp endpoint
    #
    # @see https://help.na.bambora.com/hc/en-us/articles/115010346067-Secure-Payment-Profiles-Batch-Payments
    class PaymentProfileResource
      DEFAULT_VERSION = 1.0
      DEFAULT_RESPONSE_FORMAT = 'QS'
      CREATE_OPERATION_TYPE = 'N'

      attr_reader :client, :api_key, :sub_path, :version

      ##
      # Instantiate an interface to make requests against Bambora's Profiles API.
      #
      # @example
      #
      #   client = Bambora::Rest::WWWFormClient(base_url: '...', merchant_id: '...')
      #   profiles = Bambora::Bank::PaymentProfileResource(client: client, api_key: '...')
      #
      #   # Start making requests ...
      #
      # @param client [Bambora::Rest::WWWFormClient] An instance of Bambora::Rest::WWWFormClient, used to make network requests.
      # @param api_key [String] An API key for this endpoint. This is also known as the "Pass Code"
      # @param version [String] The Service Version you are requesting from the server.
      def initialize(client:, api_key:, version: DEFAULT_VERSION)
        @client = client
        @api_key = api_key
        @version = version
        @sub_path = '/scripts/payment_profile.asp'
      end

      ##
      # Create a Bank Payment Profile
      #
      # @example
      #   data = {
      #     customer_code: '1234',
      #     bank_account_type: 'CA',
      #     bank_account_holder: 'All-Maudra Mayrin',
      #     institution_number: '123',
      #     branch_number: '12345',
      #     account_number: '123456789',
      #     name: 'Hup Podling',
      #     email_address: 'Brea Princess of Vapra',
      #     phone_number: '1231231234',
      #     address_1: 'The Castle',
      #     city: "Ha'rar",
      #     postal_code: 'H0H 0H0',
      #     province: 'Vapra',
      #     country: 'Thra',
      #   }
      #
      #  payment_profile_resource.create(data)
      #
      #  @params profile_data [Hash] with values as noted in the example.
      def create(profile_data)
        client.post(path: sub_path, body: payment_profile_body(profile_data))
      end

      private

      def payment_profile_body(profile_data)
        Bambora::Bank::Builders::PaymentProfileParams.build(
          profile_data.merge(
            pass_code: api_key,
            merchant_id: client.merchant_id,
            sub_merchant_id: client.sub_merchant_id,
            service_version: version,
            response_format: DEFAULT_RESPONSE_FORMAT,
            operation_type: CREATE_OPERATION_TYPE,
          ),
        )
      end
    end
  end
end
