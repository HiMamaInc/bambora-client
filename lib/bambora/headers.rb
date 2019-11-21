# frozen_string_literal: true

module Bambora
  class Headers
    class << self
      def build(api_key:, merchant_id:, sub_merchant_id: nil, content_type: nil)
        headers = {
          'Authorization' => "Passcode #{passcode(merchant_id, api_key)}",
        }
        headers['Content-Type'] = content_type if content_type
        headers['Sub-Merchant-Id'] = sub_merchant_id unless sub_merchant_id.nil?
        headers
      end

      def passcode(merchant_id, api_key)
        Base64.encode64("#{merchant_id}:#{api_key}").delete("\n")
      end
    end
  end
end
