# frozen_string_literal: true

require_relative '../game'

RSpec.describe Game do
  let(:player) { Player.new(100) }
  let(:game) do
    blocks = Array.new(2) { Array.new(2) }
    blocks[0][0] = Block.new('0-0')
    blocks[0][1] = Block.new('0-1')
    blocks[1][0] = Block.new('1-0')
    blocks[1][1] = Block.new('1-1')

    map = Map.new(blocks)
    described_class.new(map)
  end

  before { allow(STDOUT).to receive(:puts) }

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
    subject { game.run }

    context 'when player enters exit command' do
      before do
        allow(Readline)
          .to receive(:readline)
          .with(any_args)
          .and_return(action).once
      end

      context 'when player enters exit command' do
        let(:action) { 'exit' }

        it 'calls exit action method' do
          exit_action = Actions::ExitAction.new(game)
          expect(Actions::ExitAction).to receive(:new).and_return(exit_action)
          expect(exit_action).to receive(:do).and_call_original
          subject
        end

        it 'sets the game as exited' do
          expect { subject }
            .to change { game.status }
            .from(GameStatus::NOT_STARTED)
            .to(GameStatus::EXITED)
        end

        it 'does not output' do
          expect { subject }.not_to output.to_stdout
        end
      end

      context 'when player enters exit command with spaces after' do
        let(:action) { 'exit   ' }

        it 'sets the game as exited' do
          expect { subject }
            .to change { game.status }
            .from(GameStatus::NOT_STARTED)
            .to(GameStatus::EXITED)
        end

        it 'does not output' do
          expect { subject }.not_to output.to_stdout
        end
      end

      context 'when player enters EXIT command with uppercase' do
        let(:action) { 'EXIT' }

        it 'is case insensitive & sets the game as exited' do
          expect { subject }
            .to change { game.status }
            .from(GameStatus::NOT_STARTED)
            .to(GameStatus::EXITED)
        end

        it 'does not output' do
          expect { subject }.not_to output.to_stdout
        end
      end
    end

    context 'when player enters help command' do
      before do
        allow(Readline).to receive(:readline)
          .with(any_args).and_return('help', 'exit')
      end

      it 'calls help action method' do
        help_action = Actions::HelpAction.new(game, player)
        expect(Actions::HelpAction).to receive(:new).and_return(help_action)
        expect(help_action).to receive(:do)
        subject
      end
    end

    context 'when player enters wrong command' do
      before do
        allow(Readline).to receive(:readline)
          .with(any_args).and_return('wrong', 'exit')
      end

      it 'calls unknown action method' do
        unknown_action = Actions::UnknownAction.new(game)
        expect(Actions::UnknownAction)
          .to receive(:new)
          .and_return(unknown_action)
        expect(unknown_action).to receive(:do)
        subject
      end

      it 'outputs validation error message' do
        expect { subject }.to output(/Unknown action\./).to_stdout
      end
    end

    context 'when player moves to right' do
      before do
        game.add_player(player)
        allow(Readline).to receive(:readline)
          .with(any_args).and_return('right', 'exit')
      end

      it 'calls move action method with right direction' do
        move_action = Actions::MoveAction.new(game, player, 'right')
        expect(Actions::MoveAction)
          .to receive(:new)
          .and_return(move_action)
        expect(move_action).to receive(:do)
        subject
      end

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
      let(:life) { 60 }
      let(:damages) { 50 }

      before do
        allow(player).to receive(:rand).and_return(damages)
        allow_any_instance_of(Enemy)
          .to receive(:rand)
          .and_return(damages)
        allow(game).to receive(:rand).and_return(life)
        allow(Readline).to receive(:readline)
          .with(any_args).and_return('bottom', 'hit', 'exit')

        game.add_player(player)
        game.add_enemy(1, 0)
      end

      it 'calls hit action method' do
        hit_action = Actions::HitAction.new(
          game,
          player,
          an_instance_of(Enemy)
        )
        expect(Actions::HitAction).to receive(:new).and_return(hit_action)
        expect(hit_action).to receive(:do)
        subject
      end

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
        enemy = game.instance_variable_get(:@enemies).first

        expect { subject }.to change { enemy.life }.by(-50)
      end

      it 'hits the player back' do
        expect { subject }.to change { player.life }.by(-50)
      end

      it 'outputs player\'s life' do
        expect { subject }
          .to output(/\*\* The enemy hits you. You only have 50 XP now./)
          .to_stdout
      end

      context 'when player kills the enemy' do
        let(:life) { 20 }

        it 'sets the game as win' do
          expect { subject }
            .to change { game.status }
            .from(GameStatus::NOT_STARTED)
            .to(GameStatus::WON)
        end
      end
    end
  end
end
