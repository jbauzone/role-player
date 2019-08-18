# frozen_string_literal: true

require_relative '../../game'

RSpec.describe Actions::HelpAction do
  describe '#do' do
    before { allow(STDOUT).to receive(:puts) }

    let(:game) do
      map = Map.new(Array.new(1) { Array.new(1) })
      Game.new(map)
    end
    let(:player) { Player.new(100) }

    subject { described_class.new(game, player).do }

    it 'displays the global help section' do
      expect(game).to receive(:display).at_least(5).times
      subject
    end

    context 'when player has available actions' do
      before do
        allow(player)
          .to receive(:current_available_actions)
          .and_return([Action::HIT])

        allow(game).to receive(:display).exactly(7).times
      end

      it 'displays the player available actions' do
        expect(game)
          .to receive(:display)
          .with(/#{Action::HIT}/)
        subject
      end
    end
  end
end
