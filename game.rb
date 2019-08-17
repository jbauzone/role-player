# frozen_string_literal: true

require 'readline'
require_relative 'lib/block'
require_relative 'lib/empty_block'
require_relative 'lib/map'
require_relative 'lib/player'

# Represents the game.
class Game
  def initialize(map)
    @finished = false
    @win = false
    @map = map
    @actions = []
  end

  def add_player(player)
    @player = player
    @player.after_move = ->(pos_x, pos_y) { after_player_move(pos_x, pos_y) }
    @player.move_to(0, 0)
  end

  def run
    until @finished
      input = Readline.readline('> ', true).downcase

      if input == 'exit'
        stop
      elsif input == 'help'
        display_help
      elsif @actions.include?(input)
        do_action(input)
      else
        puts 'Unknown action. See `help` command.'
      end
    end
  end

  def win?
    @win
  end

  private

  def after_player_move(pos_x, pos_y)
    message = @map.storyline(pos_x, pos_y)
    @actions = @map.avalaible_actions(pos_x, pos_y)

    puts "#{message} (#{@actions.join('/')})"
  end

  def stop(win = false)
    @finished = true
    @win = win
  end

  def do_action(action)
    case action
    when Action::MOVE_LEFT, Action::MOVE_RIGHT, Action::MOVE_TOP, Action::MOVE_BOTTOM
      @player.move(action)
    when Action::HIT
      hit_enemy
    end
  end

  def hit_enemy
    enemy = @map.enemy_on_block(@player.pos_x, @player.pos_y)
    @player.hit(enemy)

    if enemy.dead?
      stop(true)
    else
      puts "** You hit the enemy. Only #{enemy.life} XP left."
    end
  end

  def display_help
    puts '--- ROLE-PLAYER ---'
    puts 'Global commands:'
    puts "* \033[1;4mhelp\033[0m  -   This page."
    puts "* \033[1;4mexit\033[0m  -   Ends the game. You will fail to save the Humanity and run like a coward."
    Action.description

    puts ''
    puts "Current available commands: \033[1;4m#{@actions.join('/')}\033[0m"
  end
end
