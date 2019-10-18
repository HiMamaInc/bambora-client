# frozen_string_literal: true

module Bambora
  class JSONRequest
    attr_reader :client

    def initialize(client)
      @client = client
      @path = ''
    end

    def request(method:, path:, params: {}, body: {})
      parse_response(
        client.request(method: method, path: path, params: params, body: body.to_json.to_s),
      )
    end

    private

    def parse_response(resp)
      symbolize_keys(JSON.parse(resp.body))
    end

    def symbolize_keys(obj)
      return obj unless obj.is_a?(Hash)

      obj.each_with_object({}) do |(k, v), hash|
        hash[k.to_sym] = symbolize_keys(v)
        hash
      end
    end
  end
end
