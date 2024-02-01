# frozen_string_literal: true

module Bambora
  class Credentials
    attr_reader :merchant_id, :reporting_passcode

    def initialize(options = {})
      @merchant_id = options[:merchant_id]
      @reporting_passcode = options[:reporting_passcode]
    end
  end
end
