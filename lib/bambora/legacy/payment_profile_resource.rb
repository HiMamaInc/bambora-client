# frozen_string_literal: true

module Bambora
  module Legacy
    ##
    # For making requests to the /scripts/payment_profiles.asp endpoint
    class PaymentProfileResource
      DEFAULT_VERSION = 1.0
      attr_reader :client, :api_key, :sub_path, :version

      ##
      # Instantiate an interface to make requests against Bambora's Profiles API.
      #
      # @example
      #
      #   client = Bambora::WWWFormClient(base_url: '...', api_key: '...', merchant_id: '...')
      #   profiles = Bambora::Legacy::PaymentProfileResource(client: client)
      #
      #   # Start making requests ...
      #
      # @param client [Bambora::JSONClient] An instance of Bambora::JSONClient, used to make network requests.
      # @param api_key [String] An API key for this endpoint. This is also known as the "Pass Code"
      # @param version [String] The Service Version you are requesting from the server.
      def initialize(client:, api_key:)
        @client = client
        @api_key = api_key
        @sub_path = '/scripts/payment_profiles.asp'
        @version = version || DEFAULT_VERSION
      end

      ##
      # Create a Bank Payment Profile
      #
      # @example
      #  data = {
      #   customer_code: '1234',
      #   bank_account_type: 'CA',
      #   account_holder: 'All-Maudra Mayrin',
      #   institution_number: '123',
      #   branch_number: '12345',
      #   account_number: '123456789',
      #   name: 'Hup Podling',
      #   email_address: 'Brea Princess of Vapra',
      #   phone_number: '1231231234',
      #   address_1: 'The Castle',
      #   city: "Ha'rar",
      #   postal_code: 'H0H 0H0',
      #   province: 'Vapra',
      #   country: 'Thra',
      #   sub_merchant_id: '1',
      #  }
      #
      #  payment_profile_resource.create(data)
      #
      #  @params profile_data [Hash] with values as noted in the example.
      def create(profile_data)
        format_response(
          client.post(path: sub_path, body: payment_profile_body(profile_data)),
        )
      end

      private

      def payment_profile_body(profile_data)
        Bambora::Builders::LegacyPaymentProfileParams.build(
          profile_data.merge(
            pass_code: api_key,
            merchant_id: client.merchant_id,
            sub_merchant_id: client.sub_merchant_id,
            service_version: version,
          ),
        )
      end

      def format_response(response)
        response.each_with_object({}) do |(key, val), obj|
          obj[transform(key)] = val
        end
      end

      def transform(camel_case_word)
        word = camel_case_word.to_s
        underscored_word = ''
        word.each_char { |chr| underscored_word += chr == chr.upcase ? "_#{chr.downcase}" : chr }
        underscored_word.sub(/^ord_/, '').to_sym
      end
    end
  end
end
