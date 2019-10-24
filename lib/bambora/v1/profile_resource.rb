# frozen_string_literal: true

module Bambora
  module V1
    class ProfileResource
      def initialize(client:, sub_path:)
        @client = client
        @sub_path = sub_path
      end

      def create(card_data)
        @client.request(method: :post, path: @sub_path, body: card_data)
      end

      def delete(customer_code:)
        @client.request(method: :delete, path: "#{@sub_path}/#{customer_code}")
      end
    end
  end
end
