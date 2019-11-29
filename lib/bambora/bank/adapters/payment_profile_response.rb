# frozen_string_literal: true

module Bambora
  module Bank
    module Adapters
      ##
      # Transforms hash keys from camelCase to snake_case and strips vendor-specific prefixes.
      class PaymentProfileResponse
        attr_reader :response

        def initialize(response)
          @response = response
        end

        def to_h
          parsed_query_string.each_with_object({}) do |(key, val), obj|
            obj[transform(key)] = val
          end
        end

        private

        def parsed_query_string
          Bambora::QueryStringResponse.new(response).to_h
        end

        def transform(camel_case_word)
          word = camel_case_word.to_s
          underscored_word = ''
          # This would likely be faster with regex
          word.each_char { |chr| underscored_word += chr == chr.upcase ? "_#{chr.downcase}" : chr }
          underscored_word.sub(/^ord_/, '').to_sym
        end
      end
    end
  end
end
