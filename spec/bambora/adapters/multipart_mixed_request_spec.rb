# frozen_string_literal: true

require 'spec_helper'

module Bambora
  module Adapters
    describe MultipartMixedRequest do
      subject(:multipart_request) { described_class.new(multipart_args: multipart_args) }

      let(:csv_content) do
        <<~CSV
          E,C,001,99001,09400313371,10000,1000070001,ACME Corp
          E,C,002,99002,09400313372,20000,1000070002,John Doe
          E,C,003,99003,09400313373,30000,1000070003,Jane Doe
        CSV
      end

      let(:multipart_args) do
        {
          criteria: {
            content_disposition: 'Content-Disposition: form-data; name="criteria',
            content_type: 'application/json',
            content: { process_now: 1 }.to_json,
          },
          data: {
            filename: 'merchant_1.txt',
            content_type: 'text/plain',
            content: csv_content,
          },
        }
      end

      describe '#content_type' do
        it 'returns the correct content type' do
          expect(multipart_request.content_type).to include %r{^multipart/form-data; boundary=multiparty-boundary-r}
        end
      end
    end
  end
end
