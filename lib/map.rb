# frozen_string_literal: true

# Represent a map, a list of blocks that can be crossed
# or not by a player.
class Map
  def initialize(blocks)
    @blocks = blocks
    @column = blocks[0].size
    @row = blocks.size
  end

  def avalaible_actions(pos_x, pos_y)
    actions = []
    actions << Direction::TOP if can_move_to_top?(pos_x, pos_y)
    actions << Direction::BOTTOM if can_move_to_bottom?(pos_x, pos_y)
    actions << Direction::LEFT if can_move_to_left?(pos_x, pos_y)
    actions << Direction::RIGHT if can_move_to_right?(pos_x, pos_y)

    actions
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

  def block_movable?(pos_x, pos_y)
    @blocks[pos_x][pos_y].can_move_on?
  end
end