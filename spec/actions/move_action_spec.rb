# frozen_string_literal: true

require_relative '../../game'

RSpec.describe Actions::MoveAction do
  describe '#do' do
    let(:game) do
      blocks = Array.new(1) { Array.new(2) }
      blocks[0][0] = Block.new('0-0')
      blocks[0][1] = Block.new('0-1')
      map = Map.new(blocks)
      Game.new(map)
    end
    let(:player) { Player.new(100) }

    subject { described_class.new(game, player, direction).do }

    context 'when player can move to direction' do
      let(:direction) { 'right' }

      before do
        allow(player)
          .to receive(:current_available_actions)
          .and_return([Action::MOVE_RIGHT])
      end

      it 'moves the player' do
        expect(player).to receive(:move).with(direction)
        subject
      end
    end

    context 'when player can\'t move to direction' do
      let(:direction) { 'left' }

      it 'displays an error message' do
        expect(game).to receive(:display).with('You hit the wall dumbass.')
        subject
      end
    end
  end
end
