# frozen_string_literal: true

module Bambora
  module Builders
    ##
    # Builds an XML request body from a Hash
    class XMLRequestBody
      attr_reader :body

      def initialize(body:)
        @body = body
      end

      def to_s
        "<?xml version='1.0' encoding='utf-8'?>#{Gyoku.xml(request: body)}"
      end
    end
  end
end
