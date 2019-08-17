# frozen_string_literal: true

require_relative '../game'

RSpec.describe Game do
  let(:player) { Player.new }
  let(:game) do
    blocks = Array.new(2) { Array.new(2) }
    blocks[0][0] = Block.new('0-0')
    blocks[0][1] = Block.new('0-1')
    blocks[1][0] = Block.new('1-0')
    blocks[1][1] = Block.new('1-1')

    map = Map.new(blocks)
    described_class.new(map)
  end

  describe '#add_player' do
    context 'when a player is added to the game' do
      subject { game.add_player(player) }

      it 'is placed to expected position' do
        allow(game).to receive(:after_player_move).with(any_args)
        subject
        expect(player.pos_x).to eq 0
        expect(player.pos_y).to eq 0
      end

      it 'calls the after_player_move callback' do
        expect(game).to receive(:after_player_move).with(0, 0)
        subject
      end

      it 'prints available actions with storyline' do
        expect { subject }.to output("0-0 (bottom/right)\n").to_stdout
      end
    end
  end

  describe '#add_enemy' do
    context 'when an enemy is added to the game' do
      subject { game.add_enemy(1, 0) }

      it 'is placed to expected position' do
        subject
        enemies_on_game = game.instance_variable_get(:@enemies)

        expect(enemies_on_game.size).to eq 1
        expect(enemies_on_game.first.pos_x).to eq 1
        expect(enemies_on_game.first.pos_y).to eq 0
      end
    end
  end

  describe '#run' do
    context 'when player enters exit command' do
      before do
        allow(Readline).to receive(:readline).with(any_args).and_return(action)
      end
      subject { game.run }

      context 'when player enters exit command' do
        let(:action) { 'exit' }

        it 'does not set the game as win' do
          expect { subject }.not_to change { game.win? }
        end

        it 'does not output' do
          expect { subject }.not_to output.to_stdout
        end
      end

      context 'when player enters EXIT command with uppercase' do
        let(:action) { 'EXIT' }

        it 'is case insensitive & does not set the game as win' do
          expect { subject }.not_to change { game.win? }
        end

        it 'does not output' do
          expect { subject }.not_to output.to_stdout
        end
      end
    end

    context 'when player enters wrong command' do
      before do
        allow(Readline).to receive(:readline)
          .with(any_args).and_return('wrong', 'exit')
      end

      it 'outputs validation error message' do
        expect { game.run }.to output(/Unknown action\./).to_stdout
      end
    end

    context 'when player moves to right' do
      before do
        game.add_player(player)
        allow(Readline).to receive(:readline)
          .with(any_args).and_return('right', 'exit')
      end
      subject { game.run }

      it 'moves the player to right' do
        expect { subject }.to change { player.pos_y }.by(1)
      end

      it 'outputs the new block message and actions' do
        expect { subject }.to output(%r{0-1 \(bottom/left\)}).to_stdout
      end

      it 'does not output other block message nor actions' do
        expect { subject }.not_to output(/1-1/).to_stdout
      end
    end

    context 'when player moves to block with an enemy' do
      let(:enemy) { game.instance_variable_get(:@enemies).first }
      let(:life) { 60 }
      let(:damages) { 50 }

      before do
        allow(player).to receive(:rand).and_return(damages)
        allow(game).to receive(:rand).and_return(life)
        allow(Readline).to receive(:readline)
          .with(any_args).and_return('bottom', 'hit', 'exit')

        game.add_player(player)
        game.add_enemy(1, 0)
      end
      subject { game.run }

      it 'moves the player to bottom' do
        expect { subject }.to change { player.pos_x }.by(1)
      end

      it 'outputs the new block message and actions' do
        expect { subject }.to output(/1-0 \(hit\)/).to_stdout
      end

      it 'outputs enemy\'s life' do
        expect { subject }
          .to output(/\*\* You hit the enemy. Only 10 XP left./)
          .to_stdout
      end

      it 'damages enemy life' do
        expect { subject }.to change { enemy.life }.by(-50)
      end

      context 'when player kills the enemy' do
        let(:life) { 20 }

        it 'sets the game as win' do
          expect { subject }.to change { game.win? }.from(false).to(true)
        end
      end
    end
  end
end
