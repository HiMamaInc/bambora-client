# frozen_string_literal: true

require 'faraday/multipart'
require 'faraday/excon'

module Bambora
  module Rest
    ##
    # A basic client for making REST requests.
    class Client
      attr_reader :base_url, :merchant_id, :sub_merchant_id

      # Initialze a client that makes REST requests.
      #
      # @example
      #   rest_client = Bambora::Rest::Client.new(
      #     base_url: ENV.fetch('BAMBORA_BASE_URL'),
      #     merchant_id: ENV.fetch('BAMBORA_MERCHANT_ID'),
      #     sub_merchant_id: ENV.fetch('BAMBORA_SUB_MERCHANT_ID'),
      #   )
      def initialize(options = {})
        options.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
        yield(self) if block_given?
      end

      protected

      def get(path:, params:, headers:)
        connection.get(path, params, headers)
      end

      def post(path:, body:, headers:)
        connection.post(path, body, headers)
      end

      def delete(path:, headers:)
        connection.delete(path) do |req|
          req.headers = headers
        end
      end

      def put(path:, body:, headers:)
        connection.put(path, body, headers)
      end

      def connection
        @connection ||= Faraday.new(url: base_url) do |faraday|
          faraday.request :multipart
          faraday.request :url_encoded
          faraday.adapter :excon
        end
      end

      def build_headers(api_key:, content_type: nil)
        Bambora::Builders::Headers.new(
          content_type: content_type,
          api_key: api_key,
          merchant_id: merchant_id,
          sub_merchant_id: sub_merchant_id,
        ).build
      end

      def parse_response_body(response)
        Bambora::ResponseAdapterFactory.for(response).to_h
      end
    end
  end
end
