# frozen_string_literal: true

module Bambora
  ##
  # Builds a request body for the Legacy Payment Profile endpoint from a Hash
  class LegacyPaymentProfileParams
    CONTACT_PARAMS = %w[name email_address phone_number address_1 city postal_code province country].freeze

    class << self
      ##
      # Converts a snake_case hash to camelCase keys with vendor-specific previxes.
      # See tests for examples.
      #
      # @params params [Hash]
      def build(params)
        params.each_with_object({}) do |(key, value), obj|
          obj[transform_key(key)] = value
        end
      end

      private

      def transform_key(key)
        key = key.to_s
        key = "ord_#{key}" if CONTACT_PARAMS.include?(key)

        key.split('_').map.with_index do |word, index|
          word.capitalize! unless index.zero?
          word
        end.join
      end
    end
  end
end
