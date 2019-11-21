# frozen_string_literal: true

module Bambora
  class XMLRequestBody
    class << self
      def build(body:, response_format: nil)
        body.merge!(rpt_format: response_format) if response_format
        "<?xml version='1.0' encoding='utf-8'?>#{Gyoku.xml(request: body)}"
      end
    end
  end
end
