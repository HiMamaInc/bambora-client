# frozen_string_literal: true

class Bambora::Profile
  attr_reader :client

  def initialize(client)
    @client = client
  end

  def create(card_data)
    client.post(path: path, body: card_data.to_json.to_s)
  end

  def delete(remote_id)
    client.delete(path: "#{path}/#{remote_id}")
  end

  private

  def path
    '/v1/profiles'
  end
end
