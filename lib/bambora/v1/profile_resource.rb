# frozen_string_literal: true

module Bambora
  module V1
    ##
    # For making requests to the /profiles endpoint
    class ProfileResource
      attr_reader :client, :api_key, :sub_path

      ##
      # Instantiate an interface to make requests against Bambora's Profiles API.
      #
      # @example
      #
      #   client = Bambora::Rest::JSONClient(base_url: '...', api_key: '...', merchant_id: '...')
      #   profiles = Bambora::V1::ProfileResource(client: client)
      #
      #   # Start making requests ...
      #
      # @param client [Bambora::Rest::JSONClient] An instance of Bambora::JSONClient, used to make network requests.
      def initialize(client:, api_key:)
        @client = client
        @api_key = api_key
        @sub_path = '/v1/profiles'
      end

      ##
      # Create a Bambora payment profile.
      #
      # @example
      #
      #   client = Bambora::Rest::JSONClient(base_url: '...', api_key: '...', merchant_id: '...')
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
      # @param payment_profile_data [Hash] All information relevant to making a payment.
      #
      # @see https://dev.na.bambora.com/docs/guides/payment_profiles
      #
      # @return [Hash] Indicating success or failure of the operation.
      def create(payment_profile_data)
        client.post(path: sub_path, body: payment_profile_data, api_key: api_key)
      end

      ##
      # Get a Bambora payment profile given a customer code.
      #
      # @example
      #
      #   client = Bambora::Rest::JSONClient(base_url: '...', api_key: '...', merchant_id: '...')
      #   profiles = Bambora::V1::ProfileResource(client: client)
      #   customer_code = '02355E2e58Bf488EAB4EaFAD7083dB6A'
      #
      #   profiles.get(customer_code: customer_code)
      #   # => {
      #   #      :code => 1,
      #   #      :message => "Operation Successful",
      #   #      :customer_code => "02355E2e58Bf488EAB4EaFAD7083dB6A",
      #   #      :status => "A",
      #   #      :last_transaction => "1900-01-01T00:00:00",
      #   #      :modified_date => "1900-01-01T00:00:00",
      #   #      :card => { :name => "", :number => "", :card_type => "" },
      #   #      :language => "en",
      #   #      :velocity_group => "",
      #   #      :profile_group => "",
      #   #      :account_ref => "",
      #   #      :billing =>
      #   #        {
      #   #          :name => "Harry Lewis",
      #   #          :address_line1 => "",
      #   #          :address_line2 => "",
      #   #          :city => "",
      #   #          :province => "",
      #   #          :country => "",
      #   #          :postal_code => "",
      #   #          :phone_number => "",
      #   #          :email_address => ""},
      #   #      :custom => { :ref1 => "", :ref2 => "", :ref3 => "", :ref4 => "", :ref5 => "" }}
      #
      # @param customer_code [String] A unique identifier for the associated payment profile.
      #
      # @return [Hash] Payment profile details.
      def get(customer_code:)
        client.get(path: "#{sub_path}/#{customer_code}", api_key: api_key)
      end

      # Make a PUT Request.
      #
      # @example
      #
      #   client = Bambora::Rest::JSONClient(base_url: '...', api_key: '...', merchant_id: '...')
      #   profiles = Bambora::V1::ProfileResource(client: client)
      #   customer_code = '02355E2e58Bf488EAB4EaFAD7083dB6A'
      #
      #   data = {
      #     billing: {
      #        name: "joh doe",
      #        address_line1: "123 main st",
      #        address_line2: "111",
      #        city: "victoria",
      #        province: "bc",
      #        country: "ca",
      #        postal_code: "V8T4M3",
      #        phone_number: "25012312345",
      #        email_address: "bill@smith.com"
      #     },
      #     card: {
      #       name: 'Hup Podling',
      #       number: '4030000010001234',
      #       expiry_month: '12',
      #       expiry_year: '23',
      #       cvd: '123',
      #     },
      #   }
      #
      #   profiles.update(customer_code: customer_code, payment_profile_data: data)
      #   # => {
      #   #      :code => 1,
      #   #      :message => "Operation Successful",
      #   #      :customer_code => "02355E2e58Bf488EAB4EaFAD7083dB6A",
      #   #    }
      #
      # @param customer_code [String] A unique identifier for the associated payment profile.
      # @param payment_profile_data [Hash] Payment profile data to be sent in the body of the request.
      #
      # @return [Hash] Indicating success or failure of the operation.
      def update(customer_code:, payment_profile_data:)
        client.put(path: "#{@sub_path}/#{customer_code}", body: payment_profile_data, api_key: api_key)
      end

      ##
      # Delete a Bambora payment profile given a customer code.
      #
      # @example
      #
      #   client = Bambora::Rest::JSONClient(base_url: '...', api_key: '...', merchant_id: '...')
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

      # Add a card to the specified payment profile.
      #
      # @param customer_code [String] A unique identifier for the associated payment profile.
      # @param data [Hash] Card data to be sent in the body of the request.
      #
      # @return [Hash] Indicating success or failure of the operation.
      #
      # @see https://dev.na.bambora.com/docs/guides/payment_profiles/#add-a-card
      def add_profile_card(customer_code:, data:)
        client.post(path: "#{sub_path}/#{customer_code}/cards", body: data, api_key: api_key)
      end

      # Get a list of cards associated with the specified payment profile.
      #
      # @param customer_code [String] A unique identifier for the associated payment profile.
      #
      # @return [Hash] Indicating success or failure of the operation.
      #
      # @see https://dev.na.bambora.com/docs/guides/payment_profiles/#retrieve-cards
      def get_profile_cards(customer_code:)
        client.get(path: "#{sub_path}/#{customer_code}/cards", api_key: api_key)
      end

      # Update the card expiry fields for a card in the given profile.
      #
      # @param customer_code [String] A unique identifier for the associated payment profile.
      # @param card_id [Integer] The card id to update.
      # @param data [Hash] Card data to be sent in the body of the request.
      #
      # @return [Hash] Indicating success or failure of the operation.
      #
      # @see https://dev.na.bambora.com/docs/guides/payment_profiles/#update-a-card
      def update_profile_card(customer_code:, card_id:, data:)
        client.put(path: "#{sub_path}/#{customer_code}/cards/#{card_id}", body: data, api_key: api_key)
      end

      # Delete a card from the specified payment profile.
      #
      # @param customer_code [String] A unique identifier for the associated payment profile.
      # @param card_id [Integer] The card id to delete.
      #
      # @return [Hash] Indicating success or failure of the operation.
      #
      # @see https://dev.na.bambora.com/docs/guides/payment_profiles/#delete-a-card
      def delete_profile_card(customer_code:, card_id:)
        client.delete(path: "#{@sub_path}/#{customer_code}/cards/#{card_id}", api_key: api_key)
      end
    end
  end
end
