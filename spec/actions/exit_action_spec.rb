# frozen_string_literal: true

require_relative '../../game'

RSpec.describe Actions::ExitAction do
  describe '#do' do
    let(:game) do
      map = Map.new(Array.new(1) { Array.new(1) })
      Game.new(map)
    end

    it 'stops the game' do
      expect(game).to receive(:stop).with(GameStatus::EXITED)
      described_class.new(game).do
    end
  end
end
