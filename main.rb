# frozen_string_literal: true

require_relative 'lib/player'
require_relative 'game'

row = 3
column = 3
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
map = Map.new(blocks)

player = Player.new

game = Game.new(map)
game.add_player(player)
game.add_enemy(2, 1)
game.run

puts 'Good game. You killed the QUEEN, you saved the Humanity.' if game.win?
puts 'See you soon, byebye!'
