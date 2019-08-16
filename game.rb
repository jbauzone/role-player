# frozen_string_literal: true

require 'readline'
require_relative 'lib/block'
require_relative 'lib/empty_block'
require_relative 'lib/map'
require_relative 'lib/player'

# Represents the game.
class Game
  def initialize
    row = 3
    column = 3

    init_map(row, column)
  end

  def run
    player = Player.new

    loop do
      move_actions = @map.avalaible_actions(player.pos_x, player.pos_y)
      puts move_actions.join('/')

      input = Readline.readline('> ', true)
      break if input == 'exit'

      if move_actions.include?(input)
        player.move(input)
      else
        puts 'You just hit the wall. :('
      end
    end

    puts 'Ok byebye :('
  end

  private

  def init_map(row, column)
    blocks = Array.new(row) { Array.new(column) }
    blocks[0][0] = Block.new('You are now at the beginning of the anthill. '\
                             'Where should we go ?')
    blocks[0][1] = EmptyBlock.new
    blocks[0][2] = EmptyBlock.new
    blocks[1][0] = Block.new('It starts to be dark here. You should '\
                             'start to search for a light or something.')
    blocks[1][1] = Block.new('You don\'t have any idea of what you are doing, '\
                             'ain\'t you ? Well, keep it going.')
    blocks[1][2] = Block.new('It looks like there is nothing to see here, '\
                             'it`s a dead end.')
    blocks[2][0] = EmptyBlock.new
    blocks[2][1] = Block.new('OH OH. You found the QUEEN. I know someone '\
                             'who will have some troubles.')
    blocks[2][2] = EmptyBlock.new

    @map = Map.new(blocks)
  end
end
