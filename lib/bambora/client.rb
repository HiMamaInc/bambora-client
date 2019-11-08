# frozen_string_literal: true

require 'base64'
require 'faraday'

module Bambora
  class Client
    extend Forwardable
    attr_accessor :base_url, :merchant_id, :sub_merchant_id

    def initialize(options = {})
      unless options[:version].nil?
        raise Bambora::Error, 'Only V1 endpoints are supported at this time.' if options[:version].upcase != 'V1'
      end

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
      connection.post(path, body.to_json.to_s, headers)
    end

    def delete(path:, headers:)
      connection.delete(path) do |req|
        req.headers = headers
      end
    end

    def connection
      @connection ||= Faraday.new(url: base_url) do |f|
        f.adapter :excon
      end
    end

    def build_headers(api_key)
      Bambora::Headers.build(api_key: api_key, merchant_id: merchant_id, sub_merchant_id: sub_merchant_id)
    end
  end
end
