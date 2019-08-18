# frozen_string_literal: true

require 'readline'
require_relative 'lib/block'
require_relative 'lib/empty_block'
require_relative 'lib/enemy'
require_relative 'lib/game_status'
require_relative 'lib/map'
require_relative 'lib/player'

# Represents the game.
class Game
  def initialize(map)
    @status = GameStatus::NOT_STARTED
    @map = map
    @actions = []
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

      if input == 'exit'
        stop(GameStatus::EXITED)
      elsif input == 'help'
        display_help
      elsif @actions.include?(input)
        do_action(input)
      else
        puts 'Unknown action. See `help` command.'
      end
    end
  end

  def status
    @status
  end

  private

  def after_player_move(pos_x, pos_y)
    message = @map.storyline(pos_x, pos_y)
    @actions = available_actions(pos_x, pos_y)

    puts "#{message} (#{@actions.join('/')})"
  end

  def available_actions(pos_x, pos_y)
    if enemy_present?(pos_x, pos_y)
      [Action::HIT]
    else
      @map.move_actions(pos_x, pos_y)
    end
  end

  def stop(status)
    @status = status
  end

  def do_action(action)
    case action
    when Action::MOVE_LEFT, Action::MOVE_RIGHT, Action::MOVE_TOP, Action::MOVE_BOTTOM
      @player.move(action)
    when Action::HIT
      hit_enemy
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

  def hit_enemy
    enemy = enemy_at_position(@player.pos_x, @player.pos_y)
    @player.hit(enemy)

    if enemy.dead?
      stop(GameStatus::WON)
    else
      puts "** You hit the enemy. Only #{enemy.life} XP left."
      enemy.hit(@player)
      return stop(GameStatus::FAILED) if @player.dead?

      puts "** The enemy hits you. You only have #{@player.life} XP now."
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
