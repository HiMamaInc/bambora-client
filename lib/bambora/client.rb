# frozen_string_literal: true

require 'base64'
require 'excon'

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

    def_delegators :connection, :request

    protected

    def connection
      @connection ||= Excon.new(base_url)
    end

    def headers(api_key)
      Bambora::Headers.build(api_key: api_key, merchant_id: merchant_id, sub_merchant_id: sub_merchant_id)
    end
  end
end
