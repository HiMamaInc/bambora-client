# frozen_string_literal: true

module Bambora
  module Builders
    ##
    # Builds an XML request body from a Hash
    class XMLRequestBody
      attr_reader :body, :response_format

      def initialize(body:, response_format: nil)
        @body = body
        @response_format = response_format
      end

      def to_s
        body.merge!(rpt_format: response_format) if response_format
        "<?xml version='1.0' encoding='utf-8'?>#{Gyoku.xml(request: body)}"
      end
    end
  end
end
