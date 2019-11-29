# frozen_string_literal: true

module Bambora
  module Bank
    module Builders
    ##
    # Builds a request body for the Bank Payment Profile endpoint from a Hash
      class PaymentProfileParams
        CONTACT_PARAMS = %w[name email_address phone_number address_1 address_2 city postal_code province country].freeze

        class << self
          ##
<<<<<<< HEAD
          # Converts a snake_case hash to camelCase keys with vendor-specific prefixes.
=======
          # Converts a snake_case hash to camelCase keys with vendor-specific previxes.
>>>>>>> legacy -> bank
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
  end
end
