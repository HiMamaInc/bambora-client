# frozen_string_literal: true

module Bambora
  class JSONRequest
    attr_reader :client

    def initialize(client)
      @client = client
      @path = ''
    end

    def request(method:, path:, params: {}, body: {})
      resp = client.request(method: method, path: path, params: params, body: body.to_json.to_s)
      return parse_response(resp) if resp.status <= 300

      raise Bambora::ServerError, "The remote server responded with a status of #{resp.status}: #{resp.body}"
    end

    private

    def parse_response(resp)
      deep_transform_keys_in_object(JSON.parse(resp.body), &:to_sym)
    end

    def deep_transform_keys_in_object(object, &block)
      case object
        when Hash
          object.each_with_object({}) do |(key, value), result|
            result[yield(key)] = deep_transform_keys_in_object(value, &block)
          end
        when Array
          object.map { |e| deep_transform_keys_in_object(e, &block) }
        else
          object
      end
    end
  end
end