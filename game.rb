# frozen_string_literal: true

require 'readline'
require_relative 'lib/block'
require_relative 'lib/empty_block'
require_relative 'lib/map'
require_relative 'lib/player'

# Represents the game.
class Game
  def initialize(map)
    @map = map
    @actions = []
  end

  def add_player(player)
    @player = player
    @player.after_move = ->(pos_x, pos_y) { after_player_move(pos_x, pos_y) }
    @player.move_to(0, 0)
  end

  def run
    loop do
      input = Readline.readline('> ', true)
      break if input == 'exit'

      if @actions.include?(input)
        do_action(input)
      else
        puts 'You just hit the wall. :('
      end
    end

    puts 'Ok byebye :('
  end

  private

  def after_player_move(pos_x, pos_y)
    message = @map.storyline(pos_x, pos_y)
    @actions = @map.avalaible_actions(pos_x, pos_y)

    puts "#{message} (#{@actions.join('/')})"
  end

  def do_action(action)
    case action
    when Action::MOVE_LEFT, Action::MOVE_RIGHT, Action::MOVE_TOP, Action::MOVE_BOTTOM
      @player.move(action)
    when Action::HIT
      enemy = @map.enemy_on_block(@player.pos_x, @player.pos_y)
      @player.hit(enemy)
    end
  end
end
