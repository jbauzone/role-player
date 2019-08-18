# frozen_string_literal: true

require_relative '../../game'

RSpec.describe Actions::BaseAction do
  describe '#do' do
    let(:game) do
      map = Map.new(Array.new(1) { Array.new(1) })
      Game.new(map)
    end

    it 'raises an error' do
      expect { described_class.new(game).do }
        .to raise_error(NotImplementedError)
    end
  end
end
