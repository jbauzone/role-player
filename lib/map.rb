# frozen_string_literal: true

require_relative 'action'

# Represent a map, a list of blocks that can be crossed
# or not by a player.
class Map
  def initialize(blocks)
    @blocks = blocks
    @column = blocks[0].size
    @row = blocks.size
  end

  def move_actions(pos_x, pos_y)
    move_actions = []
    move_actions << Action::MOVE_TOP if can_move_to_top?(pos_x, pos_y)
    move_actions << Action::MOVE_BOTTOM if can_move_to_bottom?(pos_x, pos_y)
    move_actions << Action::MOVE_LEFT if can_move_to_left?(pos_x, pos_y)
    move_actions << Action::MOVE_RIGHT if can_move_to_right?(pos_x, pos_y)

    move_actions
  end

  def storyline(pos_x, pos_y)
    @blocks[pos_x][pos_y].message
  end

  private

  def can_move_to_top?(pos_x, pos_y)
    pos_x.positive? && block_movable?(pos_x - 1, pos_y)
  end

  def can_move_to_bottom?(pos_x, pos_y)
    pos_x < @row - 1 && block_movable?(pos_x + 1, pos_y)
  end

  def can_move_to_left?(pos_x, pos_y)
    pos_y.positive? && block_movable?(pos_x, pos_y - 1)
  end

  def can_move_to_right?(pos_x, pos_y)
    pos_y < @column - 1 && block_movable?(pos_x, pos_y + 1)
  end

  def block_for_position(pos_x, pos_y)
    @blocks[pos_x][pos_y]
  end

  def block_movable?(pos_x, pos_y)
    block_for_position(pos_x, pos_y).can_move_on?
  end
end
