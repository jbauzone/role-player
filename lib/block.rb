# frozen_string_literal: true

# Represent a block that can be crossed by a player on the map.
class Block
  attr_reader :message
  attr_reader :enemy

  def initialize(message, enemy = nil)
    @message = message
    @enemy = enemy
  end

  def can_move_on?
    true
  end

  def enemy_to_fight?
    !enemy.nil?
  end
end
