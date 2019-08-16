# frozen_string_literal: true

require_relative 'action'

# Represents a player crossing the map.
class Player
  attr_reader :pos_x
  attr_reader :pos_y

  def initialize
    @pos_x = 0
    @pos_y = 0
  end

  def move(direction)
    case direction
    when Action::MOVE_LEFT
      move_to(@pos_x, @pos_y - 1)
    when Action::MOVE_RIGHT
      move_to(@pos_x, @pos_y + 1)
    when Action::MOVE_BOTTOM
      move_to(@pos_x + 1, @pos_y)
    when Action::MOVE_TOP
      move_to(@pos_x - 1, @pos_y)
    end
  end

  def move_to(pos_x, pos_y)
    @pos_x = pos_x
    @pos_y = pos_y
  end
end
