# frozen_string_literal: true

require_relative '../../game'

RSpec.describe Actions::UnknownAction do
  describe '#do' do
    let(:game) do
      map = Map.new(Array.new(1) { Array.new(1) })
      Game.new(map)
    end

    it 'displays the unknown message' do
      expect(game)
        .to receive(:display)
        .with('Unknown action. See `help` command.')
      described_class.new(game).do
    end
  end
end
