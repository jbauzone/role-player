# frozen_string_literal: true

require_relative '../../game'

RSpec.describe Actions::HitAction do
  describe '#do' do
    let(:game) do
      map = Map.new(Array.new(1) { Array.new(1) })
      Game.new(map)
    end
    let(:player) { Player.new(100) }
    let(:enemy) { Enemy.new(100) }

    before { allow(STDOUT).to receive(:puts) }

    subject { described_class.new(game, player, enemy).do }

    context 'when player is able to hit' do
      before do
        allow(player)
          .to receive(:current_available_actions)
          .and_return([Action::HIT])
      end

      it 'hits the enemy' do
        expect(player).to receive(:hit).with(enemy)
        subject
      end

      context 'when the enemy dies' do
        before { allow(enemy).to receive(:dead?).and_return(true) }

        it 'stops the game with win' do
          expect(game).to receive(:stop).with(GameStatus::WON)
          subject
        end
      end

      context 'when enemy is still alive' do
        let(:enemy_life) { 50 }
        before do
          allow(enemy).to receive(:dead?).and_return(false)
          allow(enemy).to receive(:life).and_return(enemy_life)
        end

        it 'is hit back by the enemy' do
          expect(enemy).to receive(:hit).with(player)
          subject
        end

        context 'when player dies' do
          before { allow(player).to receive(:dead?).and_return(true) }

          it 'hits the enemy and stops the game with fail' do
            expect(game)
              .to receive(:display)
              .with("** You hit the enemy. Only #{enemy_life} XP left.")
            expect(game).to receive(:stop).with(GameStatus::FAILED)
            subject
          end
        end

        context 'when player is still alive' do
          let(:player_life) { 10 }

          before do
            allow(player).to receive(:dead?).and_return(false)
            allow(player).to receive(:life).and_return(player_life)
          end

          it 'hits the enemy and displays player XP' do
            expect(game)
              .to receive(:display)
              .with("** You hit the enemy. Only #{enemy_life} XP left.")
            expect(game)
              .to receive(:display)
              .with("** The enemy hits you. You only have #{player_life}"\
                    ' XP now.')
            subject
          end
        end
      end
    end

    context 'when player can\'t hit the enemy' do
      it 'displays an error message' do
        expect(game)
          .to receive(:display)
          .with('Hitting is not possible when there is no ennemy.')
        subject
      end
    end
  end
end
