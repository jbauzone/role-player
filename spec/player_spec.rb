# frozen_string_literal: true

require_relative '../lib/player'

RSpec.describe Player do
  let(:player) { described_class.new }

  describe 'include Fight module' do
    it 'can hit' do
      expect(player).to respond_to(:hit).with(1).argument
    end
  end

  describe '#move' do
    before { player.move_to(0, 0) }
    subject { player.move(direction) }

    context 'when player move to right' do
      let(:direction) { Action::MOVE_RIGHT }

      it 'moves to expected position' do
        expect { subject }
          .to change { player.pos_y }
          .by(1)
          .and not_change { player.pos_x }
      end
    end

    context 'when player move to bottom' do
      let(:direction) { Action::MOVE_BOTTOM }

      it 'moves to expected position' do
        expect { subject }
          .to change { player.pos_x }
          .by(1)
          .and not_change { player.pos_y }
      end
    end

    context 'when player move to top' do
      let(:direction) { Action::MOVE_TOP }

      it 'moves to expected position' do
        expect { subject }
          .to change { player.pos_x }
          .by(-1)
          .and not_change { player.pos_y }
      end
    end

    context 'when player move to left' do
      let(:direction) { Action::MOVE_LEFT }

      it 'moves to expected position' do
        expect { subject }
          .to change { player.pos_y }
          .by(-1)
          .and not_change { player.pos_x }
      end
    end
  end

  describe '#move_to' do
    subject { player.move_to(1, 2) }

    it 'moves the player to the expected position' do
      subject
      expect(player.pos_x).to eq 1
      expect(player.pos_y).to eq 2
    end

    it 'calls the after_move method' do
      expect(player).to receive(:after_move)
      subject
    end
  end
end
