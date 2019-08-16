# frozen_string_literal: true

# Represent a block that can be crossed by a player on the map.
class Block
  attr_reader :message

  def initialize(message)
    @message = message
  end

  def can_move_on?
    true
  end
end
