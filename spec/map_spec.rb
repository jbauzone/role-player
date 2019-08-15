# frozen_string_literal: true

require_relative '../lib/block'
require_relative '../lib/empty_block'
require_relative '../lib/map'

RSpec.describe Map do
  let(:map) do
    blocks = Array.new(2) { Array.new(2) }
    blocks[0][0] = Block.new
    blocks[0][1] = EmptyBlock.new
    blocks[1][0] = Block.new
    blocks[1][1] = Block.new

    Map.new(blocks)
  end

  let(:player) { Player.new }

  describe '#avalaible_actions' do
    subject { map.avalaible_actions(player.pos_x, player.pos_y) }

    context 'when player is at position 0,0' do
      it 'can only go bottom' do
        expect(subject).to contain_exactly(Direction::BOTTOM)
      end
    end

    context 'when player is at position 1,0' do
      before { player.move_to(1, 0) }

      it 'can go top and right' do
        expect(subject).to contain_exactly(Direction::TOP, Direction::RIGHT)
      end
    end
  end
end