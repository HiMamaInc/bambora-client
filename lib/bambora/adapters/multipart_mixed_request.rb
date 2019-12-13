# frozen_string_literal: true

module Bambora
  module Adapters
    ##
    # Creates headers and a body for a multipart/mixed request with a file and a JSON body.
    class MultipartMixedRequest
      extend Forwardable

      attr_reader :multiparty

      def initialize(options = {})
        @multiparty = Multiparty.new { |party| party.parts = options[:multipart_args] }
      end

      def content_type
        multiparty.header.sub(/^Content-Type: /, '').strip
      end

      def body
       "#{multiparty.body}\r\n"
      end
    end
  end
end
