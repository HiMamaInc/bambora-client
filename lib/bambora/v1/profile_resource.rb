# frozen_string_literal: true

module Bambora
  module V1
    class ProfileResource
      def initialize(client)
        @client = client
      end

      def create(card_data)
        @client.request(method: :post, body: card_data)
      end

      def delete(customer_code:)
        @client.request(method: :delete, path: "/#{customer_code}")
      end
    end
  end
end
