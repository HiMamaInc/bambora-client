# frozen_string_literal: true

require 'bambora/client'
require 'bambora/headers'
require 'bambora/json_request'
require 'bambora/v1/profile'
require 'bambora/version'

module Bambora
  class Error < StandardError; end
  class ServerError < StandardError; end
end
