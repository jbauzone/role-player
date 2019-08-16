# frozen_string_literal: true

require_relative '../game'

RSpec.describe Game do
  let(:game) do
    blocks = Array.new(1) { Array.new(2) }
    blocks[0][0] = Block.new('hello')
    blocks[0][1] = Block.new('world')

    map = Map.new(blocks)
    described_class.new(map)
  end

  describe '#add_player' do
    context 'when a player is added to the game' do
      let(:player) { Player.new }
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
        expect { subject }.to output("hello (right)\n").to_stdout
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
  end
end
