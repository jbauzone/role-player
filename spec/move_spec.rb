# frozen_string_literal: true

require_relative '../lib/enemy'
require_relative '../lib/fight'

RSpec.describe Move do
  let(:movable) do
    class Movable
      include Move
    end

    Movable.new
  end

  describe '#move' do
    before { movable.move_to(0, 0) }
    subject { movable.move(direction) }

    context 'when someone who can move, moves to right' do
      let(:direction) { Action::MOVE_RIGHT }

      it 'moves to expected position' do
        expect { subject }
          .to change { movable.pos_y }
          .by(1)
          .and not_change { movable.pos_x }
      end
    end

    context 'when someone who can move, moves to bottom' do
      let(:direction) { Action::MOVE_BOTTOM }

      it 'moves to expected position' do
        expect { subject }
          .to change { movable.pos_x }
          .by(1)
          .and not_change { movable.pos_y }
      end
    end

    context 'when someone who can move, moves to top' do
      let(:direction) { Action::MOVE_TOP }

      it 'moves to expected position' do
        expect { subject }
          .to change { movable.pos_x }
          .by(-1)
          .and not_change { movable.pos_y }
      end
    end

    context 'when someone who can move, moves to left' do
      let(:direction) { Action::MOVE_LEFT }

      it 'moves to expected position' do
        expect { subject }
          .to change { movable.pos_y }
          .by(-1)
          .and not_change { movable.pos_x }
      end
    end
  end

  describe '#move_to' do
    subject { movable.move_to(1, 2) }

    it 'moves to the expected position' do
      subject
      expect(movable.pos_x).to eq 1
      expect(movable.pos_y).to eq 2
    end

    it 'calls the after_move method' do
      expect(movable).to receive(:after_move)
      subject
    end
  end
end
