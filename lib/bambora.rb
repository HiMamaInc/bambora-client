# frozen_string_literal: true

require 'bambora/client'
require 'bambora/headers'
require 'bambora/json_client'
require 'bambora/v1/batch_payment_report_resource'
require 'bambora/v1/batch_payment_resource'
require 'bambora/v1/profile_resource'
require 'bambora/v1/payment_resource'
require 'bambora/version'

module Bambora
  class Error < StandardError; end
  class ServerError < StandardError; end
end
