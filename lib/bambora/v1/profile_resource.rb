# frozen_string_literal: true

module Bambora
  module V1
    class ProfileResource
      def initialize(client:)
        @client = client
        @sub_path = '/v1/profiles'
      end

      def create(card_data)
        @client.request(method: :post, path: @sub_path, body: card_data)
      end

      # Delete a Bambora payment profile given a customer code.
      #
      # @example
      #
      #   client = Bambora::JSONClient(base_url: '...', api_key: '...', merchant_id: '...')
      #   profiles = Bambora::V1::ProfileResource(client: client)
      #   customer_code: '02355E2e58Bf488EAB4EaFAD7083dB6A'
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
        @client.request(method: :delete, path: "#{@sub_path}/#{customer_code}")
      end
    end
  end
end
