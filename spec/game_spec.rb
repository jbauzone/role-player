# frozen_string_literal: true

require_relative '../game'

RSpec.describe Game do
  let(:game) { Game.new }

  describe '#run' do
    context 'when player enters exit command' do
      before do
        allow(Readline).to receive(:readline).with(any_args).and_return('exit')
      end

      it 'outputs first avalaible action (bottom) and exits' do
        expect { game.run }.to output("bottom\nOk byebye :(\n").to_stdout
      end
    end

    context 'when player enters wrong command' do
      before do
        allow(Readline).to receive(:readline).with(any_args).and_return('wrong', 'exit')
      end

      it 'outputs validation error message' do
        expect { game.run }.to output(/You just hit the wall\. :\(/).to_stdout
      end
    end
  end
end
