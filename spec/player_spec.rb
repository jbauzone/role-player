# frozen_string_literal: true

require_relative '../lib/player'

RSpec.describe Player do
  let(:player) { described_class.new }

  describe '#new' do
    it 'starts at 0,0' do
      expect(player.pos_x).to eq 0
      expect(player.pos_y).to eq 0
    end
  end

  describe '#move' do
    subject { player.move(direction) }

    context 'when player move to right' do
      let(:direction) { Action::MOVE_RIGHT }

      it 'moves to expected position' do
        expect { subject }.to change { player.pos_y }.by(1)
        .and not_change { player.pos_x }
      end
    end

    context 'when player move to bottom' do
      let(:direction) { Action::MOVE_BOTTOM }

      it 'moves to expected position' do
        expect { subject }.to change { player.pos_x }.by(1)
        .and not_change { player.pos_y }
      end
    end

    context 'when player move to top' do
      let(:direction) { Action::MOVE_TOP }
      
      it 'moves to expected position' do
        expect { subject }.to change { player.pos_x }.by(-1)
        .and not_change { player.pos_y }
      end
    end

    context 'when player move to left' do
      let(:direction) { Action::MOVE_LEFT }
      
      it 'moves to expected position' do
        expect { subject }.to change { player.pos_y }.by(-1)
        .and not_change { player.pos_x }
      end
    end
  end
end
