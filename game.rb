# frozen_string_literal: true

require 'readline'
require_relative 'lib/actions/exit_action'
require_relative 'lib/actions/help_action'
require_relative 'lib/actions/hit_action'
require_relative 'lib/actions/move_action'
require_relative 'lib/actions/unknown_action'
require_relative 'lib/block'
require_relative 'lib/empty_block'
require_relative 'lib/enemy'
require_relative 'lib/game_status'
require_relative 'lib/map'
require_relative 'lib/player'

# Represents the game.
class Game
  attr_reader :status

  def initialize(map)
    @status = GameStatus::NOT_STARTED
    @map = map
    @enemies = []
  end

  def add_player(player)
    @player = player
    @player.after_move = ->(pos_x, pos_y) { after_player_move(pos_x, pos_y) }
    @player.move_to(0, 0)
  end

  def add_enemy(pos_x, pos_y)
    enemy = Enemy.new(rand(50..150))
    enemy.move_to(pos_x, pos_y)
    @enemies << enemy
  end

  def run
    @status = GameStatus::IN_PROGRESS

    while @status == GameStatus::IN_PROGRESS
      input = Readline.readline('> ', true).downcase.strip

      action = case input
               when 'exit'
                 Actions::ExitAction.new(self)
               when 'help'
                 Actions::HelpAction.new(self, @player)
               when Action::HIT
                 enemy = enemy_at_position(@player.pos_x, @player.pos_y)
                 Actions::HitAction.new(self, @player, enemy)
               when Action::MOVE_LEFT, Action::MOVE_RIGHT,
                    Action::MOVE_TOP, Action::MOVE_BOTTOM
                 Actions::MoveAction.new(self, @player, input)
               else
                 Actions::UnknownAction.new(self)
               end

      action.do
    end
  end

  def display(message)
    puts message
  end

  def stop(status)
    @status = status
  end

  private

  def after_player_move(pos_x, pos_y)
    message = @map.storyline(pos_x, pos_y)
    @player.current_available_actions = available_actions(pos_x, pos_y)

    display("#{message} (#{@player.current_available_actions.join('/')})")
  end

  def available_actions(pos_x, pos_y)
    if enemy_present?(pos_x, pos_y)
      [Action::HIT]
    else
      @map.move_actions(pos_x, pos_y)
    end
  end

  def enemy_present?(pos_x, pos_y)
    !enemy_at_position(pos_x, pos_y).nil?
  end

  def enemy_at_position(pos_x, pos_y)
    @enemies.find do |enemy|
      enemy.pos_x == pos_x && enemy.pos_y == pos_y
    end
  end
end
