# frozen_string_literal: true

module Bambora
  describe Client do
    it 'has a version number' do
      expect(Bambora::Client::VERSION).not_to be nil
    end
  end
end
