# frozen_string_literal: true

require 'bambora/client/rest_client'
require 'bambora/client/headers'
require 'bambora/client/json_client'
require 'bambora/client/v1/batch_payment_report_resource'
require 'bambora/client/v1/batch_payment_resource'
require 'bambora/client/v1/profile_resource'
require 'bambora/client/v1/payment_resource'
require 'bambora/client/version'

module Bambora
  module Client
    class Error < StandardError; end
    class ServerError < StandardError; end
  end
end
