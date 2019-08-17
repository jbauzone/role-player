# frozen_string_literal: true

require_relative '../game'

RSpec.describe Game do
  let(:enemy) { Enemy.new(60) }
  let(:player) { Player.new }
  let(:game) do
    blocks = Array.new(2) { Array.new(2) }
    blocks[0][0] = Block.new('0-0')
    blocks[0][1] = Block.new('0-1')
    blocks[1][0] = Block.new('1-0', enemy)
    blocks[1][1] = Block.new('1-1')

    map = Map.new(blocks)
    described_class.new(map)
  end

  describe '#add_player' do
    context 'when a player is added to the game' do
      subject { game.add_player(player) }

      it 'player is placed to expected position' do
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

  describe '#run' do
    context 'when player enters exit command' do
      before do
        allow(Readline).to receive(:readline).with(any_args).and_return('exit')
      end

      it 'outputs goodbye message and exits' do
        expect { game.run }.to output("Ok byebye :(\n").to_stdout
      end
    end

    context 'when player enters wrong command' do
      before do
        allow(Readline).to receive(:readline)
          .with(any_args).and_return('wrong', 'exit')
      end

      it 'outputs validation error message' do
        expect { game.run }.to output(/You just hit the wall\. :\(/).to_stdout
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
      before do
        game.add_player(player)
        allow(Readline).to receive(:readline)
          .with(any_args).and_return('bottom', 'hit', 'exit')
      end
      subject { game.run }

      it 'moves the player to bottom' do
        expect { subject }.to change { player.pos_x }.by(1)
      end

      it 'outputs the new block message and actions' do
        expect { subject }.to output(/1-0 \(hit\)/).to_stdout
      end

      it 'damages enemy life' do
        expect { subject }.to change { enemy.life }.by(-50)
      end
    end
  end
end
