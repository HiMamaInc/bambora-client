# frozen_string_literal: true

module Bambora
  module Bank
    module Builders
      ##
      # Builds a request body for the Bank Payment Profile endpoint from a Hash
      class PaymentProfileParams
        CONTACT_PARAMS =
          %w[name email_address phone_number address_1 address_2 city postal_code province country].freeze

        class << self
          ##
          # Converts a snake_case hash to camelCase keys with vendor-specific prefixes.
          # See tests for examples.
          #
          # @params params [Hash]
          def build(params)
            params.transform_keys do |key|
              transform_key(key)
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
  end
end
