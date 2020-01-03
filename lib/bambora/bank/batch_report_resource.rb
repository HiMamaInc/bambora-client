# frozen_string_literal: true

module Bambora
  module Bank
    ##
    # For making requests to the /scripts/reporting/report.aspx endpoint
    #
    # @see https://dev.na.bambora.com/docs/guides/batch_payment/report/
    class BatchReportResource
      DEFAULT_REQUEST_PARAMS = {
        rpt_format: 'JSON',
        rpt_version: '2.0',
        session_source: 'external',
      }.freeze

      attr_reader :client, :api_key, :sub_path, :version

      ##
      # Instantiate an interface to make requests against Bambora's Profiles API.
      #
      # @example
      #
      #   client = Bambora::Rest::XMLClient(base_url: '...', merchant_id: '...')
      #   profiles = Bambora::Bank::BatchReportResource(client: client, api_key: '...')
      #
      #   # Start making requests ...
      #
      # @param client [Bambora::Rest::XMLClient] An instance of Bambora::Rest::XMLClient, used to make network requests.
      # @param api_key [String] An API key for this endpoint. This is also known as the "Pass Code"
      # @param version [String] The Service Version you are requesting from the server.
      def initialize(client:, api_key:)
        @client = client
        @api_key = api_key
        @sub_path = '/scripts/reporting/report.aspx'
      end

      ##
      # Create a Bank Payment Profile
      #
      # @example
      #   data = {
      #     rpt_filter_by_1: 'batch_id',
      #     rpt_filter_value_1: 1,
      #     rpt_operation_type_1: 'EQ',
      #     rpt_from_date_time: '2019-12-18 00:00:00',
      #     rpt_to_date_time: '2019-12-18 23:59:59',
      #     service_name: 'BatchPaymentsEFT',
      #   }
      #
      #  payment_profile_resource.show(data)
      #
      #  @params profile_data [Hash] with values as noted in the example.
      def show(profile_data)
        client.post(path: sub_path, body: batch_report_body(profile_data), api_key: api_key)
      end

      private

      def batch_report_body(request_data)
        DEFAULT_REQUEST_PARAMS.merge(request_data).merge(
          merchant_id: client.merchant_id,
          pass_code: api_key,
          sub_merchant_id: client.sub_merchant_id,
        )
      end
    end
  end
end
