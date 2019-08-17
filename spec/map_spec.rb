# frozen_string_literal: true

require_relative '../lib/block'
require_relative '../lib/empty_block'
require_relative '../lib/map'

RSpec.describe Map do
  let(:pos_x) { 0 }
  let(:pos_y) { 0 }
  let(:map) do
    blocks = Array.new(2) { Array.new(2) }
    blocks[0][0] = Block.new('0-0')
    blocks[0][1] = EmptyBlock.new
    blocks[1][0] = Block.new('1-0')
    blocks[1][1] = Block.new('1-1')

    Map.new(blocks)
  end

  describe '#storyline' do
    subject { map.storyline(pos_x, pos_y) }
    it { is_expected.to eq '0-0' }
  end

  describe '#move_actions' do
    subject { map.move_actions(pos_x, pos_y) }

    context 'when player is at position 0,0' do
      it 'can only go bottom' do
        expect(subject).to contain_exactly(Action::MOVE_BOTTOM)
      end
    end

    context 'when player is at position 1,0' do
      let(:pos_x) { 1 }

      it 'can go top and right' do
        expect(subject).to contain_exactly(Action::MOVE_TOP, Action::MOVE_RIGHT)
      end
    end
  end
end
