# frozen_string_literal: true

require_relative '../lib/enemy'
require_relative '../lib/fight'

RSpec.describe Fight do
  let(:fight_player) do
    class FightPlayer
      include Fight
    end

    FightPlayer.new
  end

  describe '#hit' do
    context 'when other defines the suffered method' do
      let(:damages) { 20 }
      let(:enemy) { Enemy.new(150) }

      before { allow(fight_player).to receive(:rand).and_return(damages) }
      subject { fight_player.hit(enemy) }

      it 'calls the suffered method' do
        expect(enemy).to receive(:suffered).with(damages)
        subject
      end
    end

    context 'when other does not define the suffered method' do
      let(:enemy) do
        class FakeEnemy
        end

        FakeEnemy.new
      end
      subject { fight_player.hit(enemy) }

      it 'raises a NoMethodError' do
        expect { subject }.to raise_error(NoMethodError)
      end
    end
  end
end
