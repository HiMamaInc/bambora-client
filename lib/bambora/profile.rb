# frozen_string_literal: true

module Bambora
  class Profile < JSONRequest
    def initialize(client)
      super

      @path = '/v1/profiles'
    end

    def create(card_data)
      request(method: :post, path: @path, body: card_data)
    end

    def delete(remote_id)
      request(method: :delete, path: "#{@path}/#{remote_id}")
    end
  end
end
