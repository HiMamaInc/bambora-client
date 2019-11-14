# frozen_string_literal: true

module Bambora
  module Client
    module V1
      class ProfileResource
        attr_accessor :client, :api_key, :sub_path

        # Instantiate an interface to make requests against Bambora's Profiles API.
        #
        # @example
        #
        #   client = Bambora::JSONClient(base_url: '...', api_key: '...', merchant_id: '...')
        #   profiles = Bambora::V1::ProfileResource(client: client)
        #
        #   # Start making requests ...
        #
        # @param client [Bambora::RestClient] An instance of Bambora::JSONClient, used to make network requests.
        def initialize(client:, api_key:)
          @client = client
          @api_key = api_key
          @sub_path = '/v1/profiles'
        end

        # Create a Bambora payment profile.
        #
        # @example
        #
        #   client = Bambora::JSONClient(base_url: '...', api_key: '...', merchant_id: '...')
        #   profiles = Bambora::V1::ProfileResource(client: client)
        #   data = {
        #    language: 'en',
        #     card: {
        #       name: 'Hup Podling',
        #       number: '4030000010001234',
        #       expiry_month: '12',
        #       expiry_year: '23',
        #       cvd: '123',
        #     },
        #   }
        #
        #   profiles.create(data)
        #   # => {
        #   #      :code => 1,
        #   #      :message => "Operation Successful",
        #   #      :customer_code => "02355E2e58Bf488EAB4EaFAD7083dB6A",
        #   #    }
        #
        # @param card_data [Hash] All information relevant to making a payment.
        #
        # @see https://dev.na.bambora.com/docs/guides/payment_profiles
        #
        # @return [Hash] Indicating success or failure of the operation.
        def create(card_data)
          client.post(path: sub_path, body: card_data, api_key: api_key)
        end

        # Delete a Bambora payment profile given a customer code.
        #
        # @example
        #
        #   client = Bambora::JSONClient(base_url: '...', api_key: '...', merchant_id: '...')
        #   profiles = Bambora::V1::ProfileResource(client: client)
        #   customer_code = '02355E2e58Bf488EAB4EaFAD7083dB6A'
        #
        #   profiles.delete(customer_code: customer_code)
        #   # => {
        #   #      :code => 1,
        #   #      :message => "Operation Successful",
        #   #      :customer_code => "02355E2e58Bf488EAB4EaFAD7083dB6A",
        #   #    }
        #
        # @param customer_code [String] A unique identifier for the associated payment profile.
        #
        # @return [Hash] Indicating success or failure of the operation.
        def delete(customer_code:)
          client.delete(path: "#{@sub_path}/#{customer_code}", api_key: api_key)
        end
      end
    end
  end
end
