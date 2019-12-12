# frozen_string_literal: true

module Bambora
  module Rest
    class BatchPaymentFileUploadClient < Bambora::Rest::Client
      CONTENT_DISPOSITION = "form-data; name='criteria'"
      FILE_CONTENT_TYPE = 'text/plain'
      JSON_CONTENT_TYPE = 'application/json'

      # @param args[:file_contents] [String] CSV file contents
      # @param args[:options] [Hash] Request Parameters as documented by Bambora.
      # @param args[:api_key] [String]
      def post(args = {})
        init_payload(args[:file_contents], args[:options])
        parse_response_body(
          super(
            path: args[:path],
            body: @payload.body,
            headers: build_headers(api_key: args[:api_key])),
        ).to_h
      end

      private

      def init_payload(file_contents, params)
        return @payload if @payload

        @payload = Bambora::Adapters::MultipartMixedRequest.new(
          multipart_args: {
            criteria: {
              content_disposition: CONTENT_DISPOSITION,
              content_type: JSON_CONTENT_TYPE,
              content: params.to_json,
            },
            data: {
              filename: "merchant_#{sub_merchant_id}.txt",
              content_type: FILE_CONTENT_TYPE,
              content: file_contents,
            },
          },
        )
      end

      def build_headers(api_key:)
        Bambora::Builders::Headers.new(
          content_type: @payload.content_type,
          api_key: api_key,
          merchant_id: merchant_id,
          sub_merchant_id: sub_merchant_id,
        ).build
      end
    end
  end
end
