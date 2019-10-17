# frozen_string_literal: true

class Bambora::Headers
  class << self
    def build(passcode:, sub_merchant_id: nil)
      headers = { 'Authorization' => "Passcode #{passcode}" }
      headers['Sub-Merchant-Id'] = sub_merchant_id unless sub_merchant_id.nil?
      headers
    end
  end
end
