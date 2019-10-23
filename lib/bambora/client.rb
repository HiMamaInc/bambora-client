# frozen_string_literal: true

module Bambora
  class Client
    extend Forwardable
    attr_accessor :merchant_id, :sub_merchant_id, :api_key

    def initialize(options = {})
      unless options[:version].nil?
        raise Bambora::Error, 'Only V1 endpoints are supported at this time.' if options[:version].upcase != 'V1'

      end

      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end

      @base_url = 'https://api.na.bambora.com'

      yield(self) if block_given?
    end

    def_delegators :connection, :request

    def profile
      @profile ||= Bambora::V1::Profile.new(self)
    end

    # Summary: Create and modify payments.
    # Note: The link below links to all apis includding profiles and tokenization. There aren't great docs explaining
    #       the /payments endpoints alone.
    # Docs: https://dev.na.bambora.com/docs/references/payment_APIs/
    #       https://dev.na.bambora.com/docs/references/payment_SDKs/take_payments/?shell#
    # Endpoint: https://api.na.bambora.com/v1/payments
    def payments; end

    # Summary: Bank Electronic Funds Transfer (CAD) and Automatic Clearing House (USD)
    # Docs: https://dev.na.bambora.com/docs/guides/batch_payment/
    #       https://dev.na.bambora.com/docs/references/batch_payment/
    # Endpoint: https://api.na.bambora.com/v1/batchpayments
    def batchpayments; end

    # Summary: Statuses of batch bank-to-bank transactions.
    # Docs: https://dev.na.bambora.com/docs/guides/batch_payment/report/
    #       https://dev.na.bambora.com/docs/references/batch_payment_report/
    # Endpoint: https://na.bambora.com/scripts/reporting/report.aspx
    def batchpayment_reports; end

    protected

    def connection
      @connection ||= Excon.new(@base_url, headers: headers)
    end

    def headers
      Bambora::Headers.build(passcode: passcode, sub_merchant_id: sub_merchant_id)
    end

    def passcode
      Base64.encode64("#{merchant_id}:#{api_key}").delete("\n")
    end
  end
end
