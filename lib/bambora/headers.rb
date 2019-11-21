# frozen_string_literal: true

module Bambora
  ##
  # Builds Headers for HTTP requests.
  class Headers
    attr_reader :api_key, :merchant_id, :sub_merchant_id, :content_type

    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def build
      headers = {
        'Authorization' => "Passcode #{passcode}",
      }
      headers['Content-Type'] = content_type if content_type
      headers['Sub-Merchant-Id'] = sub_merchant_id if sub_merchant_id
      headers
    end

    private

    def passcode
      Base64.encode64("#{merchant_id}:#{api_key}").delete("\n")
    end
  end
end
