# frozen_string_literal: true

require_relative '../lib/block'

RSpec.describe Block do
  let(:enemy) { nil }
  let(:block) { described_class.new('a message', enemy) }

  describe '#new' do
    context 'when there is no enemy' do
      it 'sets the message' do
        expect(block.message).to eq 'a message'
      end

      it 'does not set the enemy' do
        expect(block.enemy).to be_nil
      end
    end

    context 'when there is one enemy' do
      let(:enemy) { Enemy.new(20) }

      it 'sets the message' do
        expect(block.message).to eq 'a message'
      end

      it 'sets the enemy' do
        expect(block.enemy).not_to be_nil
      end
    end
  end

  describe '#can_move_on?' do
    subject { block.can_move_on? }
    it { is_expected.to eq true }
  end

  describe '#enemy_to_fight?' do
    subject { block.enemy_to_fight? }

    context 'when no enemy is present on the block' do
      it { is_expected.to eq false }
    end

    context 'when enemy is present on the block' do
      let(:enemy) { Enemy.new(20) }
      it { is_expected.to eq true }
    end
  end
end
