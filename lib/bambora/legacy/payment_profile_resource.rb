# def create_profile(profile)
#  query_string =
#    set_query_string(profile.symbolize_keys).merge(@default_query_string)
#  query_string[:operationType] = 'N'
#  query_string.delete(:subMerchantId)
#  post('/scripts/payment_profile.asp', query_string)
#end

# frozen_string_literal: true

module Bambora
  module Legacy
    ##
    # For making requests to the Legacy Payment Profiles endpoint.
    class PaymentResource
      attr_reader :api_key, :client, :sub_path

      def initialize(client:, api_key:)
        @client = client
        @api_key = api_key
        @sub_path = '/scripts/payment_profile.asp'
      end

      def create(profile)
        client.post(path: sub_path, body: profile, api_key: api_key)
      end
    end
  end
end
