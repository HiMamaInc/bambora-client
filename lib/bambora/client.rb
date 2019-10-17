# frozen_string_literal: true

class Bambora::Client
  attr_accessor :merchant_id, :sub_merchant_id, :api_key

  def initialize(options = {})
    options.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
    yield(self) if block_given?
  end

  # Summary: Payment profiles store confidential payment information. Transactions can be processed against profiles.
  # Docs: https://dev.na.bambora.com/docs/guides/payment_profiles/
  # Endpoint: https://api.na.bambora.com/v1/profiles
  def profiles; end

  # Summary: Create and modify payments.
  # Note: The link below links to all apis includding profiles and tokenization. There aren't great docs explaining the
  #       /payments endpoints alone.
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
    @connection ||= Excon.new(ENV.fetch('BAMBORA_API_URL'), headers: headers, client_cert: ca_cert_path)
  end

  def headers
    Bambora::Headers.build(passcode: passcode, sub_merchant_id: sub_merchant_id)
  end

  def passcode
    Base64.encode64("#{merchant_id}:#{api_key}").delete("\n")
  end

  def ca_cert_path
    Rails.root.join('app', 'services', 'bambora', 'resources', ENV.fetch('BAMBORA_CA_CERT_NAME'))
  end
end
