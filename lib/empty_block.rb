# frozen_string_literal: true

# Represent a block that can't be crossed by a player on the map.
class EmptyBlock
  def can_move_on?
    false
  end
end
