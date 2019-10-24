# frozen_string_literal: true

require 'bambora/json_request'

module Bambora
  module V1
    class Profile < ::Bambora::JSONRequest
      def initialize(client)
        super

        @path = '/v1/profiles'
      end

      def create(card_data)
        request(method: :post, path: @path, body: card_data)
      end

      def delete(customer_code:)
        request(method: :delete, path: "#{@path}/#{customer_code}")
      end
    end
  end
end
